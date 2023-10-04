terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
    }
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config_${var.method}.cfg")
  vars = {
    address = var.address
    gateway = var.gateway
    dns_1 = var.dns_1
    dns_2 = var.dns_2
    domain = var.domain
  }
}

resource "lxd_instance" "instance" {
  name = "${var.hostname}"
  image = "${var.image_fingerprint}"
  ephemeral = false

  config = {
    "boot.autostart" = true
    "user.user-data" = data.template_file.user_data.rendered
    "user.network-config" = data.template_file.network_config.rendered
  }

  limits = {
    memory = "${var.memory}"
    cpu = "${var.vcpu}"
  }

  device {
    name = "root"
    type = "disk"
    properties = {
      "path" = "/"
      "pool" = "disks"
    }
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      "nictype" = "bridged"
      "parent" = "br0"
    }
  }
}
