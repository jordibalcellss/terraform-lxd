#dhcp assigned instance
module "guest01" {
  source = "./lxd"
  depends_on = [module.common]
  image_fingerprint = "${module.common.image_fingerprint}"
  hostname = "guest01"
}
