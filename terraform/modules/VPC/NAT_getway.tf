resource "aws_nat_gateway" "NAT_gw" {
  for_each      = aws_subnet.public_subnet
  allocation_id = aws_eip.NAT_EIP[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "taskApp_NAT_gw_${each.key}"
  }

  depends_on = [aws_internet_gateway.gw]
}

