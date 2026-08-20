module "vpc" {

  source = "../../modules/VPC"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  public_subnet_azs    = var.public_subnet_azs
  private_subnet_cidrs = var.private_subnet_cidrs
  private_subnet_azs   = var.private_subnet_azs
  cluster_name         = var.cluster_name

}


module "eks" {

  source = "../../modules/EKS"

  vpc_id = module.vpc.vpc_id

  cluster_name = var.cluster_name

  kubernetes_version = "1.35"


  private_subnet_ids = module.vpc.private_subnet_ids

  depends_on = [module.vpc]
}

module "irsa" {

  source = "../../modules/IRSA"

  oidc_provider_arn = module.eks.oidc_provider_arn

  environment = var.cluster_name

  depends_on = [module.eks]
}

module "service_accounts" {
  source       = "../../modules/service_accounts"
  alb_role_arn = module.irsa.alb_controller_role_arn
  eso_role_arn = module.irsa.external_secrets_role_arn

  depends_on = [module.irsa, module.eks]

}


module "argo-CD-irsa" {
  source            = "../../modules/Argo-CD-IRSA"
  oidc_provider_arn = module.eks.oidc_provider_arn
  depends_on        = [module.eks]
}


module "argoCD_chart" {
  source       = "../../modules/Argo-CD-Chart"
  cluster_name = var.cluster_name
  depends_on   = [module.eks]
}

module "argo_cd_add_clusters" {
  source                = "../../modules/argo-cd-add-cluster"
  prod_cluster_name     = data.terraform_remote_state.prod.outputs.cluster_name
  prod_cluster_endpoint = data.terraform_remote_state.prod.outputs.cluster_endpoint
  prod_cluster_ca_data  = data.terraform_remote_state.prod.outputs.cluster_ca_data

  devtest_cluster_name     = data.terraform_remote_state.devtest.outputs.cluster_name
  devtest_cluster_endpoint = data.terraform_remote_state.devtest.outputs.cluster_endpoint
  devtest_cluster_ca_data  = data.terraform_remote_state.devtest.outputs.cluster_ca_data

  depends_on = [ module.argoCD_chart ]

}

