resource "aws_eks_access_entry" "bastion_access_entry" {
  cluster_name  = var.cluster_name
  principal_arn = var.bastion_role_arn
}
