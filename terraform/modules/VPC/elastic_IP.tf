resource "aws_eip" "NAT_EIP" {
  for_each = aws_subnet.public_subnet

  domain = "vpc"
  tags = {
    Name = "taskApp_NAT_EIP_${each.key}"
  }
}

