resource "azurerm_mysql_server" "testmysql" {
  name                = "mysql-training"
  location            = azurerm_resource_group.testmysql.location
  resource_group_name = azurerm_resource_group.testmysql.name

  sku {
    name     = "GP_Gen5_2"
    capacity = 2
    tier     = "GeneralPurpose"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "mysqladmin"
  administrator_login_password = "P@s$w0rd!"
  version                      = "5.7"
  ssl_enforcement              = "Enabled"
}

resource "azurerm_mysql_database" "training" {
  name                = "testmysqldb"
  resource_group_name = azurerm_resource_group.testmysql.name
  #server_name         = azurerm_mysql_server.demo.name
  server_name         = azurerm_mysql_server.testmysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_virtual_network_rule" "testmysql-database-subnet-vnet-rule" {
  name                = "mysql-vnet-rule"
  resource_group_name = azurerm_resource_group.testmysql.name
  server_name         = azurerm_mysql_server.testmysql.name
  subnet_id           = azurerm_subnet.testmysql-database-1.id
}

resource "azurerm_mysql_virtual_network_rule" "testmysql-subnet-vnet-rule" {
  name                = "mysql-testmysql-subnet-vnet-rule"
  resource_group_name = azurerm_resource_group.testmysql.name
  server_name         = azurerm_mysql_server.testmysql.name
  subnet_id           = azurerm_subnet.testmysql-internal-1.id
}

resource "azurerm_mysql_firewall_rule" "testmysql-allow-testmysql-instance" {
  name                = "mysql-testmysql-instance"
  resource_group_name = azurerm_resource_group.testmysql.name
  server_name         = azurerm_mysql_server.testmysql.name
  start_ip_address    = azurerm_network_interface.mysql01-instance.private_ip_address
  end_ip_address      = azurerm_network_interface.mysql01-instance.private_ip_address
}