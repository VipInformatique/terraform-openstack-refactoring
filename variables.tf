variable "os_auth_url" {
  description = "OpenStack Identity service endpoint"
  type        = string
}

variable "os_user_name" {
  description = "Username for OpenStack"
  type        = string
}

variable "os_password" {
  description = "Password for OpenStack"
  type        = string
  sensitive   = true
}

variable "os_tenant_name" {
  description = "Tenant name for OpenStack"
  type        = string
}

variable "os_region_name" {
  description = "Region for OpenStack"
  type        = string
}