terraform {
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}
}

module "network" {
  source   = "../modules/network"
  location = var.location
}

module "aks" {
  source    = "../modules/aks"
  location  = var.location
  rg_name   = module.network.rg_name
  subnet_id = module.network.subnet_id
}
