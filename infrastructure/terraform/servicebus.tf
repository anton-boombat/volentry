resource "azurerm_servicebus_namespace" "main" {
  name                = "sb-${local.prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_servicebus_queue" "signup_events" {
  name         = "signup-events"
  namespace_id = azurerm_servicebus_namespace.main.id

  max_delivery_count = 10
  lock_duration      = "PT1M"
}

resource "azurerm_servicebus_queue" "cancellation_events" {
  name         = "cancellation-events"
  namespace_id = azurerm_servicebus_namespace.main.id

  max_delivery_count = 10
  lock_duration      = "PT1M"
}
