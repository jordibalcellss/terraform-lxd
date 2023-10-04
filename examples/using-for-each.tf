#using for_each
module "guests" {
  source = "./lxd"
  depends_on = [module.common]
  image_fingerprint = "${module.common.image_fingerprint}"
  for_each = toset(["guest01", "guest02"])
  hostname = each.value
}
