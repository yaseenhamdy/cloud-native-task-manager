resource "aws_security_group" "bastion_SG" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.bastion_SG.id
  cidr_ipv4         = "${var.machine_public_IP}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.bastion_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}