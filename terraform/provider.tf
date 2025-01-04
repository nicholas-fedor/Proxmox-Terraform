terraform {
  required_providers {
    # https://registry.terraform.io/providers/carlpett/sops/latest/docs
    sops = {
      source = "carlpett/sops"
      version = "~> 0.5"
    }
    # https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

# https://github.com/carlpett/terraform-provider-sops
data "sops_file" "proxmox_secrets" {
  source_file = "credentials.sops.tfvars.json"
}

# https://registry.terraform.io/providers/Telmate/proxmox/latest/docs#creating-the-connection-via-username-and-api-token
provider "proxmox" {
  pm_api_url          = jsondecode(data.sops_file.proxmox_secrets.raw).proxmox_api_credentials.url
  pm_api_token_id     = jsondecode(data.sops_file.proxmox_secrets.raw).proxmox_api_credentials.token_id
  pm_api_token_secret = jsondecode(data.sops_file.proxmox_secrets.raw).proxmox_api_credentials.token_secret
}
