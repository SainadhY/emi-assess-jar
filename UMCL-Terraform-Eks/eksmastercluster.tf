resource "aws_eks_cluster" "master" {
  name     = "${var.eks_cluster}"
  role_arn = "${aws_iam_role.eks_cluster_roles.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.mainsg.id}"]
    subnet_ids         = ["${aws_subnet.public.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy",
  ]
}
