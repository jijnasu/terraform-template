# We first specify the terraform provider. 
# Terraform will use the provider to ensure that we can work with Microsoft Azure

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.92.0"
    }
  }
}

# Here we need to mention the Azure AD Application Object credentials to allow us to work with 
# our Azure account

provider "azurerm" {
  features {}
}