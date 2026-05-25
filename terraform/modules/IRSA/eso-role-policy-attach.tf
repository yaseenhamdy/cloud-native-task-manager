resource "aws_iam_role_policy_attachment" "external_secrets_attach" {

  role = module.external_secrets_irsa_role.iam_role_name

  policy_arn = aws_iam_policy.external_secrets_policy.arn
}