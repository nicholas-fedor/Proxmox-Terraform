# Output VM IP Addresses
output "vm_ipv4_address" {
  #   https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#attribute-reference
  value     = proxmox_vm_qemu.ubuntu_server[*].default_ipv4_address
  sensitive = false
}
