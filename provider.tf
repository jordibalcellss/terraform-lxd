terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
    }
  }
}

provider "lxd" {
  generate_client_certificates = true
  accept_remote_certificate = true
  lxd_remote {
    name = "host"
    scheme = "https"
    address = "${var.host_server}"
    port = "${var.port}"
    password = "${trust_pwd}"
    default = true
  }
}

#create pool, volume and image
module "common" {
  source = "./lxd-common"
}
