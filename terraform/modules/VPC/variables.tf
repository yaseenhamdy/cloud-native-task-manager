variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = map(string)

  default = {
    public_1 = "10.0.1.0/24"
    public_2 = "10.0.2.0/24"
  }
}

variable "public_subnet_azs" {

  type = map(string)

  default = {
    public_1 = "us-east-1a"
    public_2 = "us-east-1b"
  }
}

variable "private_subnet_cidrs" {
  type = map(string)

  default = {
    private_1 = "10.0.3.0/24"
    private_2 = "10.0.4.0/24"
  }
}

variable "private_subnet_azs" {

  type = map(string)

  default = {
    private_1 = "us-east-1a"
    private_2 = "us-east-1b"
  }
}


variable "private_to_public_nat_mapping" {

  type = map(string)

  default = {
    private_1 = "public_1"
    private_2 = "public_2"
  }
}