output "lab_network" {
  description = "Lab network configuration"

  value = {
    name       = var.lab_network_name
    domain     = var.lab_domain
    cidr       = var.lab_cidr
    mtu        = var.lab_mtu
    gateway    = local.gateway_ip
    dhcp_start = local.dhcp_start
    dhcp_end   = local.dhcp_end
  }
}

output "lab_hosts" {
  description = "Reserved lab host addresses"

  value = {
    for name, vm in local.vms : name => {
      fqdn   = "${name}.${var.lab_domain}"
      ip     = cidrhost(var.lab_cidr, vm.host_number)
      mac    = vm.mac
      image  = vm.image
      vcpu   = vm.vcpu
      memory = "${vm.memory_mb} MiB"
    }
  }
}

output "lab_storage" {
  description = "Lab storage pool configuration"
  value = {
    pool_name = var.lab_storage_pool_name
    path      = var.lab_storage_pool_path
  }
}
