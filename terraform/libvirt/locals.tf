locals {
  # Network addressing
  gateway_ip = cidrhost(var.lab_cidr, 1)

  dhcp_start = cidrhost(var.lab_cidr, 100)
  dhcp_end   = cidrhost(var.lab_cidr, 199)

  # Base operating system images
  images = {
    debian13 = {
      url = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
    }

    rocky9 = {
      url = "https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
    }
  }

  # Lab VM inventory
  vms = {
    lab-debian01 = {
      image       = "debian13"
      host_number = 11
      mac         = "52:54:00:77:00:11"

      vcpu      = 2
      memory_mb = 2048
      disk_gb   = 16
    }

    lab-rocky01 = {
      image       = "rocky9"
      host_number = 12
      mac         = "52:54:00:77:00:12"

      vcpu      = 2
      memory_mb = 2048
      disk_gb   = 16
    }
  }
}
