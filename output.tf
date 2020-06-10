output "mysql_fqdn" {
  value = azurerm_mysql_server.testmysql.fqdn
}

output "mysql01_instance_ip" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_network_interface.mysql01-instance.private_ip_address
}

output "mysql01_instance_public_ip" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_public_ip.mysql01-instance.ip_address
}