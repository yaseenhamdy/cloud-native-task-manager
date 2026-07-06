resource "kubernetes_namespace" "namespaces" {
  for_each = var.k8s_namespaces

  metadata {
    name = each.value
  }
}

