resource "libvirt_volume" "base" {
  for_each = local.images

  name = "${each.key}-base.qcow2"
  pool = libvirt_pool.labops.name

  target = {
    format = {
      type = "qcow2"
    }
  }

  create = {
    content = {
      url = each.value.url
    }
  }
}


resource "libvirt_volume" "root" {
  for_each = local.vms

  name       = "${each.key}-root.qcow2"
  pool       = libvirt_pool.labops.name
  capacity   = each.value.disk_gb * 1024 * 1024 * 1024
  allocation = 0

  target = {
    format = {
      type = "qcow2"
    }
  }

  backing_store = {
    path = libvirt_volume.base[each.value.image].path

    format = {
      type = "qcow2"
    }
  }
}

resource "libvirt_cloudinit_disk" "init" {
  for_each = local.vms

  name = "${each.key}-cloudinit"

  meta_data = yamlencode({
    "instance-id"    = each.key
    "local-hostname" = each.key
  })

  user_data = "#cloud-config\n${yamlencode({
    users = [
      {
        name        = "labops"
        shell       = "/bin/bash"
        lock_passwd = true

        sudo = "ALL=(ALL) NOPASSWD:ALL"

        ssh_authorized_keys = [
          trimspace(file(pathexpand(var.ssh_public_key_path)))
        ]
      }
    ]

    ssh_pwauth   = false
    disable_root = true

    packages = [
      "openssh-server"
    ]

    runcmd = [
      [
        "sh",
        "-c",
        "systemctl enable --now sshd || systemctl enable --now ssh"
      ]
    ]
  })}"

  network_config = yamlencode({
    version = 2

    ethernets = {
      primary = {
        match = {
          macaddress = each.value.mac
        }

        dhcp4 = true
      }
    }
  })
}

resource "libvirt_volume" "cloudinit" {
  for_each = local.vms

  name = "${each.key}-cloudinit.iso"
  pool = libvirt_pool.labops.name

  create = {
    content = {
      url = libvirt_cloudinit_disk.init[each.key].path
    }
  }
}

resource "libvirt_domain" "vm" {
  for_each = local.vms

  name        = each.key
  description = "labops Phase 1 server"

  type        = "kvm"
  vcpu        = each.value.vcpu
  memory      = each.value.memory_mb
  memory_unit = "MiB"

  running   = true
  autostart = false

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
  }

  cpu = {
    mode = "host-passthrough"
  }

  features = {
    acpi = true

    apic = {
      eoi = "on"
    }
  }

  devices = {
    disks = [
      {
        source = {
          volume = {
            pool   = libvirt_volume.root[each.key].pool
            volume = libvirt_volume.root[each.key].name
          }
        }

        target = {
          dev = "vda"
          bus = "virtio"
        }

        driver = {
          type = "qcow2"
        }
      },

      {
        device = "cdrom"

        source = {
          volume = {
            pool   = libvirt_volume.cloudinit[each.key].pool
            volume = libvirt_volume.cloudinit[each.key].name
          }
        }

        target = {
          dev = "sda"
          bus = "sata"
        }
      }
    ]

    interfaces = [
      {
        type = "network"

        mac = {
          address = each.value.mac
        }

        model = {
          type = "virtio"
        }

        source = {
          network = {
            network = libvirt_network.labops.name
          }
        }

        wait_for_ip = {
          timeout = 300
          source  = "lease"
        }
      }
    ]

    graphics = [
      {
        vnc = {
          auto_port = true
          listen    = "127.0.0.1"
        }
      }
    ]
  }
}
