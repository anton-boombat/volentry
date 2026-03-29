resource "azurerm_container_app_environment" "main" {
  name                       = "cae-${local.prefix}"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  tags                       = local.common_tags
}

resource "azurerm_container_app" "volunteer_service" {
  name                         = "ca-volunteer-svc-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  tags                         = local.common_tags

  registry {
    server               = azurerm_container_registry.main.login_server
    username             = azurerm_container_registry.main.admin_username
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = azurerm_container_registry.main.admin_password
  }

  secret {
    name  = "appinsights-connection-string"
    value = azurerm_application_insights.main.connection_string
  }

  secret {
    name  = "cosmosdb-connection-string"
    value = azurerm_cosmosdb_account.main.primary_sql_connection_string
  }

  secret {
    name  = "servicebus-connection-string"
    value = azurerm_servicebus_namespace.main.default_primary_connection_string
  }

  template {
    min_replicas = 0
    max_replicas = 3

    container {
      name   = "volunteer-service"
      image  = var.volunteer_service_image
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "ASPNETCORE_ENVIRONMENT"
        value = var.environment == "prod" ? "Production" : var.environment == "dev" ? "Development" : "Staging"
      }

      env {
        name        = "ApplicationInsights__ConnectionString"
        secret_name = "appinsights-connection-string"
      }

      env {
        name        = "CosmosDb__ConnectionString"
        secret_name = "cosmosdb-connection-string"
      }

      env {
        name        = "ServiceBus__ConnectionString"
        secret_name = "servicebus-connection-string"
      }

      env {
        name  = "CosmosDb__DatabaseName"
        value = azurerm_cosmosdb_sql_database.volentry.name
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

resource "azurerm_container_app" "admin_service" {
  name                         = "ca-admin-svc-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  tags                         = local.common_tags

  registry {
    server               = azurerm_container_registry.main.login_server
    username             = azurerm_container_registry.main.admin_username
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = azurerm_container_registry.main.admin_password
  }

  secret {
    name  = "appinsights-connection-string"
    value = azurerm_application_insights.main.connection_string
  }

  secret {
    name  = "cosmosdb-connection-string"
    value = azurerm_cosmosdb_account.main.primary_sql_connection_string
  }

  secret {
    name  = "servicebus-connection-string"
    value = azurerm_servicebus_namespace.main.default_primary_connection_string
  }

  template {
    min_replicas = 0
    max_replicas = 2

    container {
      name   = "admin-service"
      image  = var.admin_service_image
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "ASPNETCORE_ENVIRONMENT"
        value = var.environment == "prod" ? "Production" : var.environment == "dev" ? "Development" : "Staging"
      }

      env {
        name        = "ApplicationInsights__ConnectionString"
        secret_name = "appinsights-connection-string"
      }

      env {
        name        = "CosmosDb__ConnectionString"
        secret_name = "cosmosdb-connection-string"
      }

      env {
        name        = "ServiceBus__ConnectionString"
        secret_name = "servicebus-connection-string"
      }

      env {
        name  = "CosmosDb__DatabaseName"
        value = azurerm_cosmosdb_sql_database.volentry.name
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
