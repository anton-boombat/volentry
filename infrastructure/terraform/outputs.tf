# Resource group
output "resource_group_name" {
  description = "Name of the resource group — use as AZURE_RESOURCE_GROUP secret"
  value       = azurerm_resource_group.main.name
}

# ACR — needed for GitHub Actions CD secrets
output "acr_login_server" {
  description = "ACR login server — use as AZURE_CONTAINER_REGISTRY secret"
  value       = azurerm_container_registry.main.login_server
}

output "acr_admin_username" {
  description = "ACR admin username — use as ACR_USERNAME secret"
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "ACR admin password — use as ACR_PASSWORD secret"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}

# Container App URLs
output "volunteer_service_url" {
  description = "Public URL for the Volunteer Service"
  value       = "https://${azurerm_container_app.volunteer_service.ingress[0].fqdn}"
}

output "admin_service_url" {
  description = "Public URL for the Admin Service"
  value       = "https://${azurerm_container_app.admin_service.ingress[0].fqdn}"
}

# CosmosDB
output "cosmosdb_endpoint" {
  description = "CosmosDB account endpoint"
  value       = azurerm_cosmosdb_account.main.endpoint
}

# Key Vault
output "key_vault_uri" {
  description = "Key Vault URI — used by app config for secret references"
  value       = azurerm_key_vault.main.vault_uri
}

# Application Insights
output "appinsights_instrumentation_key" {
  description = "App Insights instrumentation key"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "appinsights_connection_string" {
  description = "App Insights connection string"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}
