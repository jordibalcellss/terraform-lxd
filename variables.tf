variable "port" {
  default = 8443
  type = number
  description = "LXD daemon port"
}

variable "trust_pwd" {
  type = string
  description = "LXD daemon trust password"
}

variable "host_server" {
  default = ""
  type = string
  description = "Host server IP address"
}
