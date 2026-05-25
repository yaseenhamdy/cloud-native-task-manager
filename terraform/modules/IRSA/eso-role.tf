module "external_secrets_irsa_role" {

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  version = "5.39.0"

  role_name = "external-secrets-role"

  oidc_providers = {

    main = {

      provider_arn = var.oidc_provider_arn

      namespace_service_accounts = [
        "external-secrets:external-secrets-sa"
      ]
    }
  }
}