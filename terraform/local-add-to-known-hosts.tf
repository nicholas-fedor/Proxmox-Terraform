locals {
  #   https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#attribute-reference
  ssh_hosts = proxmox_vm_qemu.gitea[*].default_ipv4_address
}

# Add VMs to local machine's known hosts file
# https://registry.terraform.io/providers/hashicorp/null/latest/docs
resource "null_resource" "known_hosts" {
  provisioner "local-exec" {
    command     = <<EOT
    sleep 20;
    %{for host_ip in local.ssh_hosts}
        ssh-keygen -R ${host_ip}
        ssh-keyscan -H ${host_ip} >> ~/.ssh/known_hosts
    %{endfor~}
    EOT
    interpreter = ["/bin/sh", "-c"]
  }
}
