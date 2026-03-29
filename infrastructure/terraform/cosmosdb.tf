resource "azurerm_cosmosdb_account" "main" {
  name                = "cosmos-${local.prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  free_tier_enabled   = var.cosmosdb_free_tier

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }

  tags = local.common_tags
}

resource "azurerm_cosmosdb_sql_database" "volentry" {
  name                = "volentry"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name

  # Shared autoscale throughput — containers inherit this unless they set their own
  autoscale_settings {
    max_throughput = 1000
  }
}

# Event store — partition key is /orgSlug for multi-tenant isolation
resource "azurerm_cosmosdb_sql_container" "events" {
  name                = "events"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = azurerm_cosmosdb_sql_database.volentry.name
  partition_key_paths = ["/orgSlug"]

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    excluded_path {
      path = "/payload/?"
    }
  }
}

# Materialised view: volunteer events read model
resource "azurerm_cosmosdb_sql_container" "volunteer_events" {
  name                = "volunteer-events"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = azurerm_cosmosdb_sql_database.volentry.name
  partition_key_paths = ["/orgSlug"]
}

# Materialised view: signups read model
resource "azurerm_cosmosdb_sql_container" "signups" {
  name                = "signups"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = azurerm_cosmosdb_sql_database.volentry.name
  partition_key_paths = ["/orgSlug"]
}
