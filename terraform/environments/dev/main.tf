module "vpc" {

  source = "../../modules/VPC"
}

module "secret_manager" {

  source = "../../modules/secret-manager"
}


module "eks" {

  source = "../../modules/EKS"

  vpc_id = module.vpc.vpc_id

  cluster_name = "tasker-app"

  kubernetes_version = "1.33"


  private_subnet_ids = module.vpc.private_subnet_ids

  depends_on = [module.secret_manager, module.vpc]
}

module "bastion_host" {
  source = "../../modules/jump_host"

  vpc_id = module.vpc.vpc_id

  subnet_id = module.vpc.public_subnet_ids[0]

  machine_public_IP = var.machine_public_IP

  eks_cluster_name = module.eks.cluster_name

  depends_on = [ module.eks ]
}

module "irsa" {

  source = "../../modules/IRSA"

  oidc_provider_arn = module.eks.oidc_provider_arn

  depends_on = [ module.eks ]
}

module "service_accounts" {
  source       = "../../modules/service_accounts"
  alb_role_arn = module.irsa.alb_controller_role_arn
  eso_role_arn = module.irsa.external_secrets_role_arn

  depends_on = [ module.irsa , module.eks ]

}

module "helm_charts" {
  source     = "../../modules/Helm-Charts"
  depends_on = [module.eks , module.service_accounts]

  cluster_name = module.eks.cluster_name
}


module "app_namespaces" {
  source = "../../modules/k8s_namespaces"
  depends_on = [ module.eks ]
}
