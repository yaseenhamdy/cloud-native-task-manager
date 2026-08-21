variable "machine_public_IP" {
  type = string
}

variable "bastion_public_key" {
  type = string
}

variable "cluster_name" {
  type = string

}

variable "vpc_cidr" {
  type = string

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

variable "k8s_namespaces" {
  type = map(string)
}

variable "register_prod" {
  description = "Register prod-cluster in ArgoCD (requires prod remote state to exist)"
  type        = bool
  default     = false
}

variable "register_devtest" {
  description = "Register dev-test-cluster in ArgoCD (requires dev-test remote state to exist)"
  type        = bool
  default     = false
}

