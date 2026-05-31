resource "aws_vpc" "vpc_main" {
  cidr_block = var.vpc_cidr

    tags = {
    Name = "tasker-app-vpc"
  }
}