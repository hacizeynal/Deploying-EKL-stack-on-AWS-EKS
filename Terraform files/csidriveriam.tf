resource "aws_eks_addon" "csi_driver" {
  cluster_name             = aws_eks_cluster.ekl_stack_cluster.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.13.0-eksbuild.3"
  service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
}