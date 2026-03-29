locals {
  prefix = "volentry-${var.environment}"
  # ACR names cannot contain hyphens
  acr_name = "acrvolentry${var.environment}"

  common_tags = merge(var.tags, {
    environment = var.environment
    project     = "volentry"
    managed_by  = "terraform"
  })
}
