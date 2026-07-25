resource "aws_eks_access_policy_association" "argo_cd_access_policy_association" {
  cluster_name  = var.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.argoCD_role_arn

  access_scope {
    type       = "cluster"
  }

  depends_on = [ aws_eks_access_entry.argo_cd_access_entry ]
}