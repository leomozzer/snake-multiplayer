resource "random_uuid" "rg_name" {
}

resource "random_string" "random" {
  length  = 7
  special = false
  upper   = false
  numeric = false
}

resource "azurerm_resource_group" "rg" {
  name     = random_uuid.rg_name.result
  location = var.rg_location
  tags = {
    "stage" = var.stage
  }
}

resource "azurerm_service_plan" "appserviceplan" {
  name                = "asp-${random_string.random.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "web-app-${random_string.random.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true
  site_config {
    always_on           = false
    minimum_tls_version = "1.2"
    application_stack {
      node_version = "16-lts"
    }
  }
  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  }
}

resource "azurerm_app_service_source_control" "source_control" {
  app_id                 = azurerm_linux_web_app.web_app.id
  repo_url               = var.repo_url
  branch                 = "master"
  use_manual_integration = true
  use_mercurial          = false
}
