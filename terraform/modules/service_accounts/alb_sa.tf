resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name = "aws-load-balancer-controller"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.alb_role_arn
    }
    namespace = "kube-system"
  }
}

