variable "lab_network_name" {
  description = "Name of the libvirt network used by labops"
  type        = string
  default     = "labops"
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
