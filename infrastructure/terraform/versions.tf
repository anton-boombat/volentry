terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-volentry-tfstate"
    storage_account_name = "stvolentrystate"
    container_name       = "tfstate"
    # key is intentionally omitted — provide per environment at init time:
    #   terraform init -backend-config="key=volentry-dev.tfstate"
    #   terraform init -backend-config="key=volentry-staging.tfstate"
    #   terraform init -backend-config="key=volentry-prod.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}
