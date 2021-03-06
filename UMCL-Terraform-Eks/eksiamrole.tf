resource "aws_iam_role" "eks_cluster_roles" {
  name = "terraform_eks_cluster_roles"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

/*assume_role_policy = <<EOF
  {
    "Version": "2020-01-24",
    "Statement": [
      {
        "Effect": "allow",
        "principal": {
          "service": "eks.amazonaws.com"
        },
        "action": "sts:assumeRole"
      }
    ]
  }
  EOF*/

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks_cluster_roles.name}"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks_cluster_roles.name}"
}
