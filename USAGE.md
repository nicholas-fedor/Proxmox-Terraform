# Proxmox - Terraform Usage

> 🔴 Load the `.envrc` file to ensure the `SOPS_AGE_KEY_FILE` environment variable is loaded prior to running CLI commands.

## Terraform CLI

To apply the `main.tf` configuration:

```console
terraform -chdir=./terraform apply
```

Currently creates a single Ubuntu Plucky VM starting at ID 201 and IP 192.168.20.61 with the Debian-Desktop's SSH key and "nick" user.

SOPS plugin will automatically decrypt `credentials.sops.tfvars.json` file.

## SOPS CLI

> This shouldn't be necessary if using the VSCode plugin

To encrypt the Proxmox credentials.sops.tfvars file:

```console
sops --encrypt --in-place terraform/credentials.auto.tfvars.json
```

To decrypt the file:

```console
sops --decrypt --in-place terraform/credentials.sops.tfvars.json
```
