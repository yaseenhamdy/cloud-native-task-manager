resource "aws_iam_role_policy_attachment" "argo-cd-attach" {

  role = module.argo-cd-irsa-role.iam_role_name

  policy_arn = aws_iam_policy.argo-cd-policy.arn
}