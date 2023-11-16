resource "azurerm_resource_group" "example_groupe" {
  name     = "test_azure"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example_vnet" {
  name                = "test_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example_groupe.location
  resource_group_name = azurerm_resource_group.example_groupe.name
}

resource "azurerm_subnet" "example_subnet" {
  name                 = "test_subnet"
  resource_group_name  = azurerm_resource_group.example_groupe.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]  # Sous-réseau /24
}

resource "azurerm_kubernetes_cluster" "test_kubernetes" {
  name                = "test_kubernetes"
  location            = azurerm_resource_group.example_groupe.location
  resource_group_name = azurerm_resource_group.example_groupe.name
  dns_prefix          = "testkubernetes"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "local_file" "kube_config" {
  filename = ".kube/config"
  content = azurerm_kubernetes_cluster.test_kubernetes.kube_config_raw
}
