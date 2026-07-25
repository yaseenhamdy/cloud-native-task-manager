module "argo-cd-irsa-role" {

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  version = "5.39.0"

  role_name = "argo-cd-role"

  oidc_providers = {

    main = {

      provider_arn = var.oidc_provider_arn

      namespace_service_accounts = [
        "argo-cd:argo-cd-argocd-application-controller"
      ]
    }
  }
}