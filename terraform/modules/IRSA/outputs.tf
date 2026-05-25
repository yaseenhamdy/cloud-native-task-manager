output "external_secrets_role_arn" {

  value = module.external_secrets_irsa_role.iam_role_arn
}

output "alb_controller_role_arn" {

  value = module.alb_controller_irsa_role.iam_role_arn
}