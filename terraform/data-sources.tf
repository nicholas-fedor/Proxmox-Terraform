# Load local SSH Key for injecting into VMs
data "local_file" "ssh_public_key" {
  filename = pathexpand("${var.cloud_init_user["ssh_keyfile"]}")
}
