resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion_key"
  public_key = var.bastion_public_key
}
