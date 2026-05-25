resource "aws_route_table_association" "private_association" {
  for_each  = aws_subnet.private_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.private_route[
    var.private_to_public_nat_mapping[each.key]
  ].id
}

