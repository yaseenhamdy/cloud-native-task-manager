resource "kubernetes_service_account" "eso_sa" {
  metadata {
    name = "external-secrets-sa"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.eso_role_arn
    }
    namespace = kubernetes_namespace.eso_namespace.metadata[0].name
  }
}

