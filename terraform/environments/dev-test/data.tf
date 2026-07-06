data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_secretsmanager_secret" "secret_manager" {
  name = "postgres_secrets"
  
}