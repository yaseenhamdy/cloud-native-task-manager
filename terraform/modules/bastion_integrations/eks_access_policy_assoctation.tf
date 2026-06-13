resource "aws_eks_access_policy_association" "bastion_access_policy_association" {
  cluster_name  = var.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.bastion_role_arn

  access_scope {
    type       = "cluster"
  }

  depends_on = [ aws_eks_access_entry.bastion_access_entry ]
}