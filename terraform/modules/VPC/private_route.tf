resource "aws_route_table" "private_route" {

  for_each = aws_nat_gateway.NAT_gw
  
  vpc_id = aws_vpc.vpc_main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = each.value.id
  }

  tags = {
    Name = "private-route-${each.key}"
  }
}

