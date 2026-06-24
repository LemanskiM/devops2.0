terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}

# 🔹 NETWORK = source of infra
module "network" {
  source    = "../../modules/network"
  rg_name   = var.rg_name
  location  = var.location
  vnet_name = "vnet-dev"
}

# 🔹 AKS = consumes network output
module "aks" {
  source       = "../../modules/aks"
  cluster_name = "aks-dev"
  location     = var.location

  rg_name   = var.rg_name # ✅ FIX: from variable, not module
  subnet_id = module.network.subnet_id
}

module "argocd" {
  source = "../../modules/argocd"

  depends_on = [module.aks]
}

module "monitoring" {
  source = "../../modules/monitoring"
}

module "ingress" {
  source     = "../../modules/ingress"
  depends_on = [module.aks]
}