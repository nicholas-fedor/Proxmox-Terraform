# Proxmox - Terraform

Terraform playbook for automating the provisioning of Ubuntu Server Cloud-Init virtual machines on Proxmox.

## Usage

### Prerequisites

- Proxmox installed and running
- Proxmox administrator with an active API Token
- Terraform installed on your local machine
  > A "Dockerized" Terraform instance may be used instead.
- An Ubuntu Server template available for Terraform to clone

#### Proxmox Installation

> [Official Proxmox VE ISO Download Website](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso)

There are numerous [official](https://pve.proxmox.com/wiki/Installation) and [third-party](https://phoenixnap.com/kb/install-proxmox) guides for installing Proxmox.

#### Proxmox User Configuration

1. Create a new Proxmox user that will be used by Terraform:

   ```console
   Datacenter > Permissions > Users > Add
   ```

   > Username: `terraform`

2. Add `Administrator` role to the new user:

   ```console
   Datacenter > Permissions > Add > User Permissions
   ```

   > Path: `/`  
   > User: `terraform`  
   > Role: `Administrator`

3. Create an API Token for the user:

   ```console
   Datacenter > Permissions > API Tokens > Add
   ```

   > User: `terraform@pam`  
   > Token ID: `terraform`  
   > Privilege Separation: `disable`

   🚨 **Save the token before proceeding!** 🚨

#### Terraform Installation on Ubuntu/Debian

> [Official Hashicorp Terraform Download Website](https://developer.hashicorp.com/terraform/install)

<ins>Quick Installation</ins>

1. Download my `install-terraform.sh` Bash script:

   ```console
   wget https://github.com/nicholas-fedor/Proxmox-Terraform/blob/b79bf00f147d7b5046f763b1bef5d1d58313de3e/install-terraform.sh
   ```

2. Add the execute permission:

   ```console
   sudo chmod +x install-terraform.sh
   ```

3. Run the script with Sudo privileges:

   ```console
   sudo bash ./install-terraform.sh
   ```

<ins>Manual Installation</ins>

1. Download Hashicorp's GPG key:

   ```console
   wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   ```

2. Add the GPG key to the apt sources keyring:

   ```console
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   ```

3. Update and install `terraform`:

   ```console
   sudo apt update && sudo apt install -y terraform
   ```

#### Setup an Ubuntu Server template on Proxmox

> Reference my [Proxmox Template Creator](https://github.com/nicholas-fedor/Proxmox-Template-Creator) repository for building a template using Hashicorp's Packer.

The [Proxmox wiki](https://pve.proxmox.com/wiki/Cloud-Init_Support) details the process of manually creating an Ubuntu Cloud-Init template.

### Terraform Configuration

1. Copy the `credentials.auto.tfvars.sample` and `vm-configuration.auto.tfvars.sample` files:

   ```console
   cp ./terraform/templates/proxmox.auto.tfvars.template ./terraform/proxmox.auto.tfvars
   cp ./terraform/templates/vm-configuration.auto.tfvars.template ./terraform/vm-configuration.auto.tfvars
   ```

2. Update the `credentials.auto.tfvars` file with your configuration.

   > There is an option to either manually specify a SSH key file or set its value within the configuration.

3. Review the `main.tf` file for specific options regarding VM configuration.

   > If using my [Proxmox Template Creator](), then you should not need to make any updates.
   > Future updates may provide greater resiliency to variances in configuration.

### Running Terraform

#### <ins>Without Docker</ins>

- Create a Terraform workspace specific to your environment:

  ```console
  workspace='testing' make new
  ```

- If you have pre-existing VMs that you wish to manage using Terraform, then you can use the following command to import a VM QEMU Resource:

  > Run from within the `terraform` directory

  ```console
  terraform import [options] [node]/[type]/[vmId]
  ```

- Run `terraform init`, `terraform validate`, `terraform plan`, and `terraform apply` in a single command:

  🚨 **Remember that this will make modifications to your infrastructure, including possibly deleting and/or modifying pre-existing VMs!** 🚨

  ```console
  make
  ```

> You can also run each command individually i.e. `make init` to execute specific commands.

#### <ins>With Docker</ins>

- Terraform Init:

  ```console
  make docker-init
  ```

- Terraform Plan:

  ```console
  make docker-plan
  ```

- Terraform Apply:

  ```console
  make docker-apply
  ```

- Terraform Destroy:

  ```console
  make docker-destroy
  ```

## Expected Results

Terraform will create a fully copy of the template.
My VM configuration includes the following:

VM Options

- Name: ubuntu-server-1
- Start at boot: No
- OS Type: Linux 6.x - 2.6 Kernel
- Boot Order: scsi0
- QEMU Guest Agent: Enabled

Hardware

- Memory: 512MiB Minimum / 2GiB Maximum
- Processors: 2 (1 sockets, 2 cores) [host]
- BIOS: OVMF (UEFI)
- Machine: q35
- SCSI Controller: VirtIO SCSI single
- CloudInit Drive (ide2): local-zfs:vm-100-cloudinit,media=cdrom,size=4M
- Hard Disk (scsi0): local-zfs:vm-100-disk-1,cache=writeback,discard=on,iothread=1,size=35G,ssd=1
- Network Device (net0): virtio,bridge=vmbr0
- EFI Disk: local-zfs:vm-100-disk-0,efitype=4m,pre-enrolled-keys=0,size=1M

Cloud-Init

- User: ubuntu
- SSH public key: [key from ~/.ssh/id_ed25519.pub]
- Upgrade packages: Yes
- IP Config: ipv4=192.168.1.100,gw=192.168.1.1

If using my repository to generate the template, then you may also have your local Apt Cache and mirror configurations, along with whatever other configurations you decide to include in your template.

## Cleanup

- To remove VMs created by Terraform:

  ```console
  make destroy
  ```

- To delete the workspace:

  ```console
  workspace='testing' make delete
  ```

## Further Configuration/Modifications

Terraform has a ton of functionality, including the creation of Cloud-Init templates and setting up provisioned VMs.
I may add updates to this repository in the future.
Bear in mind that this setup may become outdated in the future due to fluctuations in both Terraform, third-party maintainers of provisioning tools, and Proxmox.

## Additional Documentation

- https://developer.hashicorp.com/terraform/docs
- https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
- https://pve.proxmox.com/pve-docs/pve-admin-guide.html
- https://pve.proxmox.com/pve-docs/index.html
- https://pve.proxmox.com/wiki/Main_Page
