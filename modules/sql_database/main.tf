resource "azurerm_mssql_server" "sql_server" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  version                      = "12.0"
  
  // Using built-in properties for `sku` and `storage_profile`
  minimum_tls_version = "1.2"

  public_network_access_enabled = true
}

resource "azurerm_mssql_database" "sql_database" {
  name           = "${var.name}-db"
  server_id      = azurerm_mssql_server.sql_server.id
  sku_name       = "S0"
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 5
  license_type   = "LicenseIncluded"
}

output "connection_string" {
  value = azurerm_mssql_server.sql_server.administrator_login
}
