# credentials.auto.tfvars
variable "proxmox_api_credentials" {
  description = "Proxmox API login information"
  type        = map(string)
  sensitive   = true
  nullable    = false
  default = {
    "url"          = "",
    "token_id"     = "",
    "token_secret" = ""
  }
}

# Telmate Proxmox Provider Reference Documentation: https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu
# vm-configuration.auto.tfvars
# variable "vm_id_start" {
#   description = "Start of VM ID range"
#   type        = number
#   default     = 100
# }

variable "proxmox_host" {
  description = "Proxmox host/node name"
  type        = string
  nullable    = false
  default     = "pve"
}

variable "proxmox_host_storage_pool1_name" {
  description = "Proxmox hosts's local block storage device name"
  type        = string
  nullable    = false
  default     = "local-lvm"
}

variable "proxmox_host_storage_pool2_name" {
  description = "Proxmox hosts's local block storage device name"
  type        = string
  nullable    = true
}

variable "template_name" {
  description = "Proxmox template name"
  type        = string
  nullable    = false
}

// Applying a 0 count
# variable "vm_count" {
#   description = "Number of clones to create"
#   type        = number
#   default     = 1
#   nullable    = false
# }

# variable "vm_name" {
#   description = "Standardized VM name applied to clones"
#   type        = string
#   nullable    = false
# }

variable "vm_bios" {
  description = "VM BIOS type i.e. seabios or ovmf"
  type        = string
  nullable    = false
  default     = "ovmf"
  validation {
    condition     = var.vm_bios == "seabios" || var.vm_bios == "ovmf"
    error_message = "BIOS must be either seabios or ovmf"
  }
}

variable "vm_bootdisk" {
  description = "Name of the VM's primary disk drive"
  type        = string
  nullable    = false
  default     = "scsi0"
}

variable "vm_qemu_guest_agent_enabled" {
  description = "1 = True/Enabled | 0 = False/Disabled"
  type        = number
  nullable    = false
  default     = 1
  validation {
    condition     = var.vm_qemu_guest_agent_enabled == 1 || var.vm_qemu_guest_agent_enabled == 0
    error_message = "Value must either be 1 or 0"
  }
}

variable "vm_full_clone" {
  description = "VM a full clone or linked clone"
  type        = bool
  default     = true
}

variable "vm_memory_max" {
  description = "Max memory allocation for VM"
  type        = number
  nullable    = false
  default     = 2048
}

variable "vm_memory_min" {
  description = "Min memory allocation for VM. If null, then memory ballooning disabled."
  type        = number
  nullable    = true
}

variable "vm_cpu_cores" {
  description = "VM CPU core allocation"
  type        = number
  nullable    = false
  default     = 1
}

# https://pve.proxmox.com/pve-docs/pve-admin-guide.html#_qemu_cpu_types
# https://pve.proxmox.com/pve-docs/chapter-qm.html#_cpu_type
variable "vm_cpu_type" {
  description = "QEMU CPU emulation type"
  type        = string
  nullable    = false
  default     = "host"
}

variable "vm_scsihw" {
  description = "VM SCSI controller emulation type"
  type        = string
  nullable    = false
  default     = "lsi"
}

# variable "vm_tags" {
#   description = "VM Tags"
#   type        = string
#   nullable    = true
# }

variable "vm_os_type" {
  description = "Provisioning method to use"
  type        = string
  nullable    = true
  default     = "cloud-init"
  validation {
    condition     = var.vm_os_type == "ubuntu" || var.vm_os_type == "centos" || var.vm_os_type == "cloud-init"
    error_message = "Options: ubuntu, centos, or cloud-init"
  }
}

variable "vm_cloud_init_upgrade" {
  description = "Upgrade packages on first boot"
  type        = bool
  nullable    = false
  default     = false
}

variable "cloud_init_user" {
  description = "User information (i.e. name, password, SSH public key) to add to the VM"
  type        = map(string)
  sensitive   = true
  nullable    = false
  default = {
    "name"        = "ubuntu",
    "password"    = "",
    "ssh_key"     = "",
    "ssh_keyfile" = "~/.ssh/id_rsa.pub"
  }
}

# variable "vm_ipv4_address_prefix" {
#   description = "IPv4 address prefix, i.e. 192.168.1.11x"
#   type        = string
# }

# variable "vm_ipv4_address_cidr" {
#   description = "IPv4 address CIDR, i.e. /24, /16, etc"
#   type        = string
#   nullable    = true
# }

variable "vm_ipv4_address_gateway" {
  description = "IPv4 gateway, i.e. 192.168.1.1"
  type        = string
}

variable "vm_cloud_init_disk" {
  description = "VM Cloud Init disk"
  type        = map(string)
  default = {
    "type"    = "cloudinit",
    "slot"    = "ide2",
    "storage" = "local-lvm"
  }
  nullable = true
}

variable "vm_primary_disk" {
  description = "VM's primary disk"
  type        = map(string)
  default = {
    "type"       = "disk",
    "slot"       = "scsi0",
    "storage"    = "local-lvm",
    "size"       = "35G",
    "discard"    = false,
    "emulatessd" = false,
    "iothread"   = "true",
    "cache"      = "writeback",
    "replicate"  = "false"
  }
  nullable = false
}
