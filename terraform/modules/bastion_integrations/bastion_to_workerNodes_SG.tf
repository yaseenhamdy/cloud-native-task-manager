resource "aws_security_group_rule" "ssh_for_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = var.bastion_SG_ID
  security_group_id        = var.node_SG_ID
}
