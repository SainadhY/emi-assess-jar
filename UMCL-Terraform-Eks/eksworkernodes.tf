#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EC2 Security Group to allow networking traffic
#  * Data source to fetch latest EKS worker AMI
#  * AutoScaling Launch Configuration to configure worker instances
#  * AutoScaling Group to launch worker instances
#

resource "aws_iam_role" "app-node" {
  name = "terraform-eks-app-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "app-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.app-node.name}"
}

resource "aws_iam_role_policy_attachment" "app-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.app-node.name}"
}

resource "aws_iam_role_policy_attachment" "app-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.app-node.name}"
}

resource "aws_iam_instance_profile" "app-node" {
  name = "terraform-eks-app"
  role = "${aws_iam_role.app-node.name}"
}

resource "aws_security_group" "app-node" {
  name        = "terraform-eks-app-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.my_app.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "terraform-eks-app-node",
     "kubernetes.io/cluster/${var.eks_cluster}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "app-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.app-node.id}"
  source_security_group_id = "${aws_security_group.app-node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "app-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.app-node.id}"
  source_security_group_id = "${aws_security_group.mainsg.id}"
  to_port                  = 65535
  type                     = "ingress"
}

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

locals {
  app-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.master.endpoint}' --b64-cluster-ca '${aws_eks_cluster.master.certificate_authority.0.data}' '${var.eks_cluster}'
USERDATA
}

resource "aws_launch_configuration" "app" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.app-node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "t2.micro"
  name_prefix                 = "terraform-eks-app"
  security_groups             = ["${aws_security_group.app-node.id}"]
  user_data_base64            = "${base64encode(local.app-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.app.id}"
  max_size             = 2
  min_size             = 1
  name                 = "terraform-eks-app"
  vpc_zone_identifier  = ["${aws_subnet.public.*.id}"]

  tag {
    key                 = "Name"
    value               = "terraform-eks-app"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.eks_cluster}"
    value               = "owned"
    propagate_at_launch = true
  }
}
