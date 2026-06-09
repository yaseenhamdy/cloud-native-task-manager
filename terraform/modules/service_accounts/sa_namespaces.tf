resource "kubernetes_namespace" "eso_namespace" {
  metadata {
    name = "external-secrets"
  }
}