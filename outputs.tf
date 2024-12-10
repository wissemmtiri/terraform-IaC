output "web_app_name" {
  value       = azurerm_linux_web_app.linux_webapp.name
  description = "The name of the deployed web app"
}

output "web_app_container" {
  value       = azurerm_linux_web_app.linux_webapp.site_config[0].linux_fx_version
  description = "The Docker image version being used by the web app"
}
