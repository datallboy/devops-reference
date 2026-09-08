resource "libvirt_pool" "labops" {
  name = var.lab_storage_pool_name
  type = "dir"

  target = {
    path = var.lab_storage_pool_path
  }

  create = {
    build     = true
    start     = true
    autostart = true
  }

  destroy = {
    delete = false
  }
}
