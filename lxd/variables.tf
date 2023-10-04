variable "hostname" {
  default = "guest"
  type = string
  description = "Hostname"
}

variable "domain" {
  default = "local"
  type = string
  description = "Search domain"
}

variable "memory" {
  default = "128MB"
  type = string
  description = "Memory in megabytes"
}

variable "vcpu" {
  default = 1
  type = number
  description = "Number of virtual cores"
}

variable "method" {
  default = "dhcp"
  type = string
  description = "Address assign method, either static or dhcp"
}

variable "address" {
  default = ""
  type = string
  description = "IP address in CIDR notation"
}

variable "gateway" {
  default = ""
  type = string
  description = "Default gateway"
}

variable "dns_1" {
  default = ""
  type = string
  description = "Primary nameserver"
}

variable "dns_2" {
  default = ""
  type = string
  description = "Secondary nameserver"
}

variable "image_fingerprint" {
  default = ""
  type = string
  description = "Variable to pass the fingeprint across modules initialized as an empty string"
}

variable "deploy_account" {
  default = "deploy"
  type = string
  description = "Deployment account username"
}

variable "deploy_account_pwd" {
  type = string
  description = "Deployment account password"
}
