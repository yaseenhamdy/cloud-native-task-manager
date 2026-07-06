module "alb_controller_irsa_role" {

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  version = "5.39.0"

  role_name = "alb-controller-role-${var.environment}"

  oidc_providers = {

    main = {

      provider_arn = var.oidc_provider_arn

      namespace_service_accounts = [
        "kube-system:aws-load-balancer-controller"
      ]
    }
  }
}