module "vpc" {

  source = "../../modules/VPC"
}

module "secret_manager" {

  source = "../../modules/secret-manager"
}

module "eks" {

  source = "../../modules/EKS"

  vpc_id  = module.vpc.vpc_id

  cluster_name = "tasker-app"

  kubernetes_version = "1.33"


  private_subnet_ids = module.vpc.private_subnet_ids

  depends_on = [module.secret_manager]
}

module "irsa" {

  source = "../../modules/IRSA"

  oidc_provider_arn = module.eks.oidc_provider_arn
}
