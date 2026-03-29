variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "australiaeast"
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "cosmosdb_free_tier" {
  description = "Enable CosmosDB free tier (only one per subscription)"
  type        = bool
  default     = false
}

variable "volunteer_service_image" {
  description = "Volunteer Service container image (e.g. acr.azurecr.io/volunteer-service:latest)"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "admin_service_image" {
  description = "Admin Service container image (e.g. acr.azurecr.io/admin-service:latest)"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "acr_admin_enabled" {
  description = "Enable ACR admin user (needed for GitHub Actions CD)"
  type        = bool
  default     = true
}
