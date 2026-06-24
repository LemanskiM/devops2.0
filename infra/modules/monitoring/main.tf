resource "helm_release" "monitoring" {
  name       = "monitoring"
  namespace  = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "55.5.0"

  create_namespace = true

  # ważne dla stabilności
  skip_crds = false

  values = [
    file("${path.module}/values.yaml")
  ]
}