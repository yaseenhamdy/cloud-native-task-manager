resource "aws_iam_instance_profile" "bastion_role_profile" {
  name = "bastion_role_profile-${var.environment}"
  role = aws_iam_role.bastion_role.name
}