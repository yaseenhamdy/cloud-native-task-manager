resource "aws_iam_role_policy_attachment" "alb_controller_attach" {

  role = module.alb_controller_irsa_role.iam_role_name

  policy_arn = aws_iam_policy.alb_controller_policy.arn
}