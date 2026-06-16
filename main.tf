# 1. Terraform Configuration and Providers Setup
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

# 2. Resource Group Creation
resource "azurerm_resource_group" "rg_szkolenie" {
  name     = "rg-devops-2-0-mateusz"
  location = "North Europe"
}

# 3. Virtual Network Creation
resource "azurerm_virtual_network" "vnet_szkolenie" {
  name                = "vnet-devops-2-0"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_szkolenie.location
  resource_group_name = azurerm_resource_group.rg_szkolenie.name
}

# 4. Subnet Creation (Dedicated network slice for Kubernetes Nodes)
resource "azurerm_subnet" "aks_subnet" {
  name                 = "snet-aks-prod"
  resource_group_name  = azurerm_resource_group.rg_szkolenie.name
  virtual_network_name = azurerm_virtual_network.vnet_szkolenie.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 5. Azure Kubernetes Service (AKS) Cluster Creation
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-devops-szkolenie"
  location            = azurerm_resource_group.rg_szkolenie.location
  resource_group_name = azurerm_resource_group.rg_szkolenie.name
  dns_prefix          = "mateusz-k8s-dns"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_EC2as_v5" # Allowed SKU on your Free Trial
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  # FIX: Network profile MUST be inside the cluster block
  network_profile {
    network_plugin     = "kubenet"
    service_cidr       = "10.244.0.0/16" # Internal K8s services range
    dns_service_ip     = "10.244.0.10"   # K8s CoreDNS IP
    pod_cidr           = "10.243.0.0/16" # Pods IP range
  }

  tags = {
    Environment = "Szkolenie"
    Owner       = "Mateusz"
  }
}


