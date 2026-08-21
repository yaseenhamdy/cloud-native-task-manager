locals {

  clusters = { for key, cluster in var.clusters : key => cluster if cluster != null }
}


resource "kubernetes_secret" "clusters_add" {
  for_each = local.clusters

  metadata {
    name      = "${each.key}-cluster"
    namespace = "argo-cd"
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  type = "Opaque"

  data = {
    name   = each.value.name
    server = each.value.endpoint
    config = jsonencode({
      execProviderConfig = {
        command    = "argocd-k8s-auth"
        args       = ["aws", "--cluster-name", each.value.name]
        apiVersion = "client.authentication.k8s.io/v1beta1"
      }
      tlsClientConfig = {
        insecure = false
        caData   = each.value.ca_data
      }
    })
  }

}
