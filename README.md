# hcloud virtual server terraform module

This terraform module will provision one or more virtual machines on hcloud (Hetzner Cloud).

All virtual servers will end up connected in the same private network.

## Quick Start

main.tf

```terraform
module "terraform_hcloud_vm" {
  source = "git::https://gitlab.com/sebastian.schmid/terraform-hcloud-vm"

  ssh_public_key  = var.ssh_public_key
  vms             = var.vms
}
```

terraform.tfvars

```terraform
hcloud_token   = "YOURTOKENHERE"
ssh_public_key = "~/.ssh/id_rsa.pub"

vms = {
  1 = {
    name               = "playground.somedomain.de"
    private_ip_address = "10.10.0.2"
    server_type        = "cx11"
    image              = "debian-10"
    location           = "fsn1"
    backups            = false
  },
}
```
