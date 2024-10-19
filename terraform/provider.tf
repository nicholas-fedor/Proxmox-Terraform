terraform {
  required_providers {
    proxmox = {
      # https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

# https://registry.terraform.io/providers/Telmate/proxmox/latest/docs#creating-the-connection-via-username-and-api-token
provider "proxmox" {
  pm_api_url          = var.proxmox_api_credentials["url"]
  pm_api_token_id     = var.proxmox_api_credentials["token_id"]
  pm_api_token_secret = var.proxmox_api_credentials["token_secret"]
  pm_tls_insecure     = true
}
