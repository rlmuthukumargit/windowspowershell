variable "resource_group_name" {
  default     = "rmuthurgroup"
  type        = string
  description = "Name of the resource group"
}

variable "resource_group_location" {
  default     = "North Europe" #also works with AustraliaSoutheast
  type        = string
  description = "Name of the resource group location"
}

variable "storage_account_name" {
  default     = "muthukumarstorage123"
  type        = string
  description = "Name of the storage account"
}
variable "keyvault_name" {
  default     = muthukumarkvl123
  type        = string
  description = "Name of the storage account"
}
#variable "storage_account_container_name" {
#  type        = string
#  description = "Name of the container inside the storage account"
#}