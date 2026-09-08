variable "lab_network_name" {
  description = "Name of the libvirt network used by labops"
  type        = string
  default     = "labops"
}

variable "lab_bridge_name" {
  description = "Name of the virbr"
  type        = string
  default     = "virbr-labops"
}

variable "lab_domain" {
  description = "DNS domain used inside the lab network"
  type        = string
  default     = "lab.test"
}

variable "lab_cidr" {
  description = "IPv4 CIDR used by the lab network"
  type        = string
  default     = "192.168.77.0/24"
}

variable "lab_storage_pool_name" {
  description = "Libvirt storage pool used for lab VM volumes"
  type        = string
  default     = "labops"
}

variable "lab_storage_pool_path" {
  description = "Filesystem path backing the labops libvirt storage pool"
  type        = string
  default     = "/mnt/vm-store/labops"
}

variable "ssh_public_key_path" {
  description = "SSH public key installed for the labops user"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
