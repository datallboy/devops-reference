resource "libvirt_network" "labops" {
  name      = var.lab_network_name
  autostart = true

  bridge = {
    name = var.lab_bridge_name
  }

  mtu = {
    size = var.lab_mtu
  }

  forward = {
    mode = "nat"
  }

  domain = {
    name       = var.lab_domain
    local_only = "yes"
  }

  dns = {
    enable = "yes"
  }

  ips = [
    {
      address = local.gateway_ip
      netmask = cidrnetmask(var.lab_cidr)

      dhcp = {
        ranges = [
          {
            start = local.dhcp_start
            end   = local.dhcp_end
          }
        ]

        # Fixed DHCP reservations for our servers.
        hosts = [
          for name, vm in local.vms : {
            name = name
            mac  = vm.mac
            ip   = cidrhost(var.lab_cidr, vm.host_number)
          }
        ]
      }
    }
  ]
}
