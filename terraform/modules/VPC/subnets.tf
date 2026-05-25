resource "aws_subnet" "public_subnet" {
  for_each                = var.public_subnet_cidrs
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  availability_zone       = var.public_subnet_azs[each.key]
  tags = {
    Name = each.key

    "kubernetes.io/role/elb" = "1"

    "kubernetes.io/cluster/tasker-app" = "shared"
  }
}


resource "aws_subnet" "private_subnet" {
  for_each                = var.private_subnet_cidrs
  vpc_id                  = aws_vpc.vpc_main.id
  map_public_ip_on_launch = false
  cidr_block              = each.value
  availability_zone       = var.private_subnet_azs[each.key]
  tags = {
    Name = each.key

    "kubernetes.io/role/internal-elb" = "1"

    "kubernetes.io/cluster/tasker-app" = "shared"
  }
}
