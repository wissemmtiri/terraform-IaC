output "web_app_name" {
  value       = azurerm_linux_web_app.linux_webapp.name
  description = "The name of the deployed web app"
}

output "web_app_container" {
  value       = azurerm_linux_web_app.linux_webapp.site_config[0].linux_fx_version
  description = "The Docker image version being used by the web app"
}

output "jenkins_ip" {
  value       = azurerm_public_ip.public-ip.ip_address
  description = "The public IP address of the Jenkins node"
}

output "jenkins_ssh_key" {
  value       = tls_private_key.ssh.private_key_pem
  description = "The private SSH key for the Jenkins node"
  sensitive = true
}