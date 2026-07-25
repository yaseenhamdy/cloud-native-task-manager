resource "aws_eks_access_entry" "argo_cd_access_entry" {
  cluster_name  = var.cluster_name
  principal_arn = var.argoCD_role_arn
}
