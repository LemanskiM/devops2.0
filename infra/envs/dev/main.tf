terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "network" {
  source    = "../../modules/network"
  rg_name   = var.rg_name
  location  = var.location
  vnet_name = "vnet-dev"
}

module "aks" {
  source       = "../../modules/aks"
  cluster_name = "aks-dev"
  location     = var.location
  rg_name      = module.network.rg_name
  subnet_id    = module.network.subnet_id
}