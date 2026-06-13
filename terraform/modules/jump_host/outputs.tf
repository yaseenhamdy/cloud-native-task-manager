output "bastion_SG_ID" {
  value = aws_security_group.bastion_SG.id
}

output "bastion_role_arn" {
  value = aws_iam_role.bastion_role.arn
}