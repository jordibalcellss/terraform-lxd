#statically assigned instance
module "guest01" {
  source = "./lxd"
  depends_on = [module.common]
  image_fingerprint = "${module.common.image_fingerprint}"
  hostname = "guest01"
  method = "static"
  address = "10.12.0.111/24"
  gateway = "10.12.0.1"
}

#dhcp assigned instance
module "guest02" {
  source = "./lxd"
  depends_on = [module.common]
  image_fingerprint = "${module.common.image_fingerprint}"
  hostname = "guest02"
  memory = "512MB"
  vcpu = 2
}
