## libvirt VM compatibility notes

### Q35 ACPI/APIC

The lab uses the Q35 machine type.

With the current `dmacvicar/libvirt` provider, ACPI/APIC are configured

```hcl
features = {
  acpi = true

  apic = {
    eoi = "on"
  }
}
```

Without these feature, the initial lab VMs did not boot into a useable state and their PCI/virtio networking did not initialize correctly.

### CPU model
Lab VMs use:

```hcl
cpi = {
  mode = "host-passthrough"
}
```

The provider's default qemu64 CPU model was insufficient for Rocky Linux 9, which requires x86-64-v2 capable CPU. Rocky stalled during early boot until host-passthrough was used.

`host-passthrough` is appropriate for this single-host disposable lab.
If VM portability/live migration becomes a requirement later, replace this with an explicitly chosen portable CPU baseline.
