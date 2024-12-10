#================================================================================================
#                                     COMMON RESOURCES
#================================================================================================
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "tf-app-service-rg"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "app-service-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
}

#================================================================================================
#                                       APP SERVICE
#================================================================================================
resource "azurerm_service_plan" "asp" {
  name                = "app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "linux_webapp" {
  name                = "tf-linux-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = false

    application_stack {
      docker_image_name = "nginx:latest"
      # mtiriwissem/mytho-front:2.0
      docker_registry_url = "https://index.docker.io"
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  }

  public_network_access_enabled = true

  tags = {
    environment = var.environment
  }
}

#================================================================================================
#                                     MONITORING NODE
#================================================================================================
# resource "azurerm_public_ip" "public-ip" {
#   name                = "public-ip"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Dynamic"
#   sku                 = "Basic"
# }

# resource "azurerm_network_interface" "nic" {
#   name                = "nic"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "nic-ip-config"
#     subnet_id                     = azurerm_subnet.subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.public-ip.id
#   }
# }

# resource "tls_private_key" "ssh" {
#   algorithm = var.ssh_key_algorithm
#   rsa_bits  = var.ssh_key_size
# }

# resource "azurerm_linux_virtual_machine" "vm" {
#   name                  = "Monitoring-VM"
#   location              = azurerm_resource_group.rg.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   network_interface_ids = [azurerm_network_interface.nic.id]
#   size                  = var.vm_size

#   os_disk {
#     name                 = "os-disk"
#     caching              = "ReadWrite"
#     storage_account_type = var.storage_account_type
#   }

#   source_image_reference {
#     publisher = var.source_image_publisher
#     offer     = var.source_image_offer
#     sku       = var.source_image_sku
#     version   = "latest"
#   }

#   computer_name                   = "mon"
#   admin_username                  = "wess"
#   disable_password_authentication = true

#   admin_ssh_key {
#     username   = var.admin_username
#     public_key = tls_private_key.ssh.public_key_openssh
#   }

#   tags = {
#     environment = var.environment
#   }
# }