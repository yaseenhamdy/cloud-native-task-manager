data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}
