
resource "azurerm_virtual_network" "testmysql" {
  name                = "${var.prefix}-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.testmysql.name
  address_space       = ["172.16.0.0/16"]
  #address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "testmysql-internal-1" {
  name                 = "${var.prefix}-internal-1"
  resource_group_name  = azurerm_resource_group.testmysql.name
  virtual_network_name = azurerm_virtual_network.testmysql.name
  address_prefix       = "172.16.0.0/24"
  #address_prefix       = "10.0.0.0/24"
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_subnet" "testmysql-database-1" {
  name                 = "${var.prefix}-database-1"
  resource_group_name  = azurerm_resource_group.testmysql.name
  virtual_network_name = azurerm_virtual_network.testmysql.name
  address_prefix       = "172.16.1.0/24"
  #address_prefix       = "10.0.1.0/24"
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_network_security_group" "allow-ssh" {
    name                = "${var.prefix}-allow-ssh"
    location            = var.location
    resource_group_name = azurerm_resource_group.testmysql.name

    security_rule {
        name                       = "SSH"
        priority                   = 310
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.ssh-source-address
        destination_address_prefix = "*"
    }
}
