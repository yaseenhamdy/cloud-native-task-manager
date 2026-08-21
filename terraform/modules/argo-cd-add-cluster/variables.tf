variable "clusters" {
  description = "Map of EKS clusters to register in ArgoCD. Entries set to null are skipped."
  type = map(object({
    name     = string
    endpoint = string
    ca_data  = string
  }))
  default = {}
}
