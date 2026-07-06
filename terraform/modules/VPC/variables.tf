variable "vpc_cidr" {
  type    = string
}

variable "public_subnet_cidrs" {
  type = map(string)


}

variable "public_subnet_azs" {

  type = map(string)

}

variable "private_subnet_cidrs" {
  type = map(string)

}

variable "private_subnet_azs" {

  type = map(string)
}


variable "private_to_public_nat_mapping" {

  type = map(string)

  default = {
    private_1 = "public_1"
    private_2 = "public_2"
  }
}

variable "cluster_name" {
  type = string
}