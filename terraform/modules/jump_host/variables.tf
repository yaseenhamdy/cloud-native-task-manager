variable "bastion_name" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "machine_public_IP" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "bastion_public_key" {
  type = string
}

variable "k8s_namespaces" {
  type = map(string)  
}

variable "environment" {
  type = string
}