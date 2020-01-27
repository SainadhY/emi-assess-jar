resource "aws_security_group" "mainsg" {
  name        = "allow_ssh_jenkins"
  description = "Allow SSH and Jenkins inbound traffic"
  vpc_id      = "${aws_vpc.my_app.id}"

  ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  # Works for EKS Cluster communication with worker nodes also.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*resource "aws_security_group" "eks_cluster_sg" {
  name        = "terraform_eks_cluster_sg"
  description = "Cluster communication with worker nodes."
  vpc_id      = "${aws_vpc.my_app.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    name = "terraform_eks"
  }
}*/

