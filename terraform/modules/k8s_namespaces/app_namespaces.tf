resource "kubernetes_namespace" "dev_namespace" {
  metadata {
    name = "dev"
  }
}

resource "kubernetes_namespace" "test_namespace" {
  metadata {
    name = "test"
  }
}

resource "kubernetes_namespace" "prod_namespace" {
  metadata {
    name = "prode"
  }
}