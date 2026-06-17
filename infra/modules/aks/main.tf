resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = "aks-dns"
    lifecycle {
    ignore_changes = [
      oidc_issuer_enabled
    ]
  }



  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size = "Standard_ec2as_v5"
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

network_profile {
  network_plugin = "kubenet"

  service_cidr = "10.244.0.0/16"
  dns_service_ip = "10.244.0.10"
  pod_cidr = "10.243.0.0/16"
}
}