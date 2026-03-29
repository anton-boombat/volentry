data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                = "kv-${local.prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  tags = local.common_tags
}

# Allow the deploying principal (CI/CD service principal) full access
resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover"
  ]
}

# Store CosmosDB connection string in Key Vault
resource "azurerm_key_vault_secret" "cosmosdb_connection_string" {
  name         = "CosmosDb--ConnectionString"
  value        = azurerm_cosmosdb_account.main.primary_sql_connection_string
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.deployer]
}

# Store Service Bus connection string in Key Vault
resource "azurerm_key_vault_secret" "servicebus_connection_string" {
  name         = "ServiceBus--ConnectionString"
  value        = azurerm_servicebus_namespace.main.default_primary_connection_string
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.deployer]
}

# Store App Insights connection string in Key Vault
resource "azurerm_key_vault_secret" "appinsights_connection_string" {
  name         = "ApplicationInsights--ConnectionString"
  value        = azurerm_application_insights.main.connection_string
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.deployer]
}
