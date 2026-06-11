output "oidc_provider_arn" {

  value = module.eks.oidc_provider_arn
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "node_SG_ID" {
  value = module.eks.node_security_group_id
}