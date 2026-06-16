# ==============================================================================
# WARSTWA APLIKACYJNA KUBERNETES (Helm Delivery Layer)
# ==============================================================================

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# 1. Native Helm Configuration via mounted Kubeconfig
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# 2. Deploy Nginx Ingress Controller via official repository charts
resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-basic"
  create_namespace = true

  values = [<<-YAML
controller:
  replicaCount: 1
YAML
  ]
}
