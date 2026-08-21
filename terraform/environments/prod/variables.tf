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

variable "enable_argocd_integration" {
  description = "Create EKS access entry for ArgoCD (requires tools remote state to contain argo_cd_irsa_role_arn)"
  type        = bool
  default     = false
}

