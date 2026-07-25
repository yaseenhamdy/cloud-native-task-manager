resource "helm_release" "argoCD_chart" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.7.11"  
  namespace        = "argo-cd"
  create_namespace = true
  wait = true
}