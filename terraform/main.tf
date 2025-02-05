# https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu
resource "proxmox_vm_qemu" "ubuntu_server" {
  count       = var.vm_count
  vmid        = var.vm_id_start + count.index
  name        = "${var.vm_name}-${count.index + 1}"
  bios        = var.vm_bios
  target_node = var.proxmox_host
  boot        = "order=${var.vm_bootdisk}"
  bootdisk    = var.vm_bootdisk
  agent       = var.vm_qemu_guest_agent_enabled
  clone       = var.template_name
  full_clone  = var.vm_full_clone
  memory      = var.vm_memory_max
  balloon     = var.vm_memory_min
  cores       = var.vm_cpu_cores
  cpu         = var.vm_cpu_type
  scsihw      = var.vm_scsihw
  tags        = var.vm_tags
  os_type     = var.vm_os_type
  ciuser      = var.cloud_init_user["name"]
  cipassword  = var.cloud_init_user["password"]
  ciupgrade   = var.vm_cloud_init_upgrade
  sshkeys     = <<EOF
  ${var.cloud_init_user["ssh_key"]}
  ${trimspace(data.local_file.ssh_public_key.content)}
  EOF
  ipconfig0   = "ip=${var.vm_ipv4_address_prefix}${count.index + 1}/${var.vm_ipv4_address_cidr},gw=${var.vm_ipv4_address_gateway}"

  # https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#network-block
  network {
    model    = "virtio"
    bridge   = "vmbr1"
    tag      = -1
    firewall = false
  }

  # https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#disk-block
  disk {
    type    = var.vm_cloud_init_disk["type"]
    slot    = var.vm_cloud_init_disk["slot"]
    storage = var.vm_cloud_init_disk["storage"]
  }

  # https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#disk-block
  disk {
    slot       = var.vm_primary_disk["slot"]
    storage    = var.vm_primary_disk["storage"]
    type       = var.vm_primary_disk["type"]
    size       = var.vm_primary_disk["size"]
    discard    = var.vm_primary_disk["discard"]
    emulatessd = var.vm_primary_disk["emulatessd"]
    iothread   = var.vm_primary_disk["iothread"]
    cache      = var.vm_primary_disk["cache"]
    replicate  = var.vm_primary_disk["replicate"]
  }
}
