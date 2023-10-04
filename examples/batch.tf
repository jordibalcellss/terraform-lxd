#using count and random hostnames
variable "instances" { default = 3 }

resource "random_string" "hostname" {
  length = 4
  special = false
  upper = false
  count = "${var.instances}"
}

module "guests" {
  source = "./lxd"
  depends_on = [module.common]
  image_fingerprint = "${module.common.image_fingerprint}"
  hostname = "${random_string.hostname[count.index].result}"
  count = "${var.instances}"
}
