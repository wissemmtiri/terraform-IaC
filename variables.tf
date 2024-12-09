#GENERAL VARIABLES
variable "resource_group_location" {
  description = "The location of the resource group."
  default     = "East US"
}

variable "environment" {
  description = "The environment of the resources."
  default     = "dev"
}

#NETWORK VARIABLES
variable "vnet_address_space" {
  description = "The address space for the virtual network."
  default     = ["10.10.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "The address prefix for the subnet."
  default     = ["10.10.1.0/24"]
}

#VIRTUAL MACHINE VARIABLES
variable "vm_size" {
  description = "The size of the virtual machine."
  default     = "Standard_DS2_v2"
}

variable "source_image_publisher" {
  description = "The publisher of the source image."
  default     = "Canonical"
}

variable "source_image_offer" {
  description = "The offer of the source image."
  default     = "0001-com-ubuntu-server-jammy"
}

variable "source_image_sku" {
  description = "The sku of the source image."
  default     = "22_04-lts-gen2"
}

variable "storage_account_type" {
  description = "The storage account type for the os disk."
  default     = "Standard_LRS"
}

#CONNECTIVITY VARIABLES
variable "admin_username" {
  description = "The username for the admin."
  default     = "wess"
}

variable "ssh_key_size" {
  description = "The size of the ssh key."
  default     = 4096
}

variable "ssh_key_algorithm" {
  description = "The algorithm of the ssh key."
  default     = "RSA"
}

variable "docker_image" {
  description = "The docker image to run."
  default     = "nginx"
}