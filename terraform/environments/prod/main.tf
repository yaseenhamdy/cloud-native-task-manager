module "vpc" {

  source = "../../modules/VPC"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  public_subnet_azs    = var.public_subnet_azs
  private_subnet_cidrs = var.private_subnet_cidrs
  private_subnet_azs   = var.private_subnet_azs
}


module "eks" {

  source = "../../modules/EKS"

  vpc_id = module.vpc.vpc_id

  cluster_name = var.cluster_name

  kubernetes_version = "1.33"


  private_subnet_ids = module.vpc.private_subnet_ids

  depends_on = [module.vpc]
}

module "bastion_host" {
  source = "../../modules/jump_host"

  bastion_name = "prod-bastion"

  vpc_id = module.vpc.vpc_id

  subnet_id = module.vpc.public_subnet_ids[0]

  k8s_namespaces    = var.k8s_namespaces

  machine_public_IP = var.machine_public_IP

  eks_cluster_name = module.eks.cluster_name

  bastion_public_key = var.bastion_public_key
  
  environment = "prod"

  depends_on = [module.eks]
}


module "bastion_integrations" {

  source = "../../modules/bastion_integrations"

  cluster_name = module.eks.cluster_name

  bastion_role_arn = module.bastion_host.bastion_role_arn

  bastion_SG_ID = module.bastion_host.bastion_SG_ID

  node_SG_ID = module.eks.node_SG_ID

  depends_on = [module.bastion_host, module.eks]
}

module "irsa" {

  source = "../../modules/IRSA"

  oidc_provider_arn = module.eks.oidc_provider_arn

  environment = "prod"

  depends_on = [module.eks]
}

module "service_accounts" {
  source       = "../../modules/service_accounts"
  alb_role_arn = module.irsa.alb_controller_role_arn
  eso_role_arn = module.irsa.external_secrets_role_arn

  depends_on = [module.irsa, module.eks]

}

module "helm_charts" {
  source     = "../../modules/Helm-Charts"
  depends_on = [module.eks, module.service_accounts]

  cluster_name = module.eks.cluster_name
}


module "app_namespaces" {
  source         = "../../modules/k8s_namespaces"
  k8s_namespaces = var.k8s_namespaces
  depends_on     = [module.eks]
}
