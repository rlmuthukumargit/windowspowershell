terraform {
  required_version = ">= 1.11.4"
  required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = ">=4.0.1"
      }
    }
  }
  provider "azurerm" {
    resource_provider_registrations = "none"
    subscription_id = "82693c4e-d89a-4007-93b4-798d75906eb3"
    features {}
  }