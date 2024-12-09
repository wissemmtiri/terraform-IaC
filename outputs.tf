output "jenkins_public_ip" {
  value = azurerm_public_ip.jenkins-public-ip.ip_address
}

output "jenkins_ssh_private_key" {
  value     = tls_private_key.jenkins-ssh.private_key_pem
  sensitive = true
}

output "web_app_name" {
  value = azurerm_linux_web_app.linux_webapp.name
  description = "The name of the deployed web app"
}

output "web_app_container" {
  value = azurerm_linux_web_app.linux_webapp.site_config[0].linux_fx_version
  description = "The Docker image version being used by the web app"
}
