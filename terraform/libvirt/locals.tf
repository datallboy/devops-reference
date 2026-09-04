locals {
  gateway_ip = cidrhost(var.lab_cidr, 1)

  dhcp_start = cidrhost(var.lab_cidr, 100)
  dhcp_end   = cidrhost(var.lab_cidr, 199)

  vms = {
    lab-debian01 = {
      host_number = 11
      mac         = "52:54:00:77:00:11"
    }

    lab-rocky01 = {
      host_number = 12
      mac         = "52:54:00:77:00:12"
    }
  }
}
