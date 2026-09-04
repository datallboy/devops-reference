output "lab_network" {
  description = "Lab network configuration"

  value = {
    name       = var.lab_network_name
    domain     = var.lab_domain
    cidr       = var.lab_cidr
    gateway    = local.gateway_ip
    dhcp_start = local.dhcp_start
    dhcp_end   = local.dhcp_end
  }
}

output "lab_hosts" {
  description = "Reserved lab host addresses"

  value = {
    for name, vm in local.vms : name => {
      ip  = cidrhost(var.lab_cidr, vm.host_number)
      mac = vm.mac
    }
  }
}
