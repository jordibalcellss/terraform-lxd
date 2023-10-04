terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
    }
  }
}

resource "lxd_storage_pool" "disks" {
  name = "disks"
  driver = "lvm"
  config = {
    size = "10GB"
  }
}

resource "lxd_volume" "volume" {
  name = "volume"
  pool = lxd_storage_pool.disks.name
}

resource "lxd_cached_image" "image" {
  source_remote = "images"
  source_image = "centos/7/cloud"
}

output "image_fingerprint" {
  value = lxd_cached_image.image.fingerprint
}
