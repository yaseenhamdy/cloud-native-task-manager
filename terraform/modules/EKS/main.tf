module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  enable_cluster_creator_admin_permissions = true


  
  enable_irsa = true
  authentication_mode = "API_AND_CONFIG_MAP"


  iam_role_name = "${var.cluster_name}-cluster-role"

  eks_managed_node_groups = {
    default = {
      instance_types           = ["t3.medium"]
      min_size                 = 5
      max_size                 = 7
      desired_size             = 6
      iam_role_name            = "${var.cluster_name}-node-role"
      iam_role_attach_cni_policy = true
    }
  }

  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
}