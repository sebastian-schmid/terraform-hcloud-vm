# hcloud virtual server Terraform module

This Terraform module will provision one or more virtual servers on [hcloud](https://www.hetzner.com/de/cloud) (Hetzner Cloud).

## Features

* all virtual servers will end up connected in the same private network.

* an ansible inventory file will be generated

* minimal required variables and working defaults you can customize to your needs

## Quick Start

main.tf

```terraform
provider "hcloud" {
  token = var.hcloud_token
}

module "hcloud_vm" {
  source  = "sebastian-schmid/vm/hcloud"

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

## Optional variables

All optional variables with their default values:

```terraform
hcloud_location = "fsn1"

private_ip_range = "10.10.0.0/16"

ssh_public_key_name = "default"

private_network_name = "default"

private_network_zone = "eu-central"

ansible_hostgroup_name = "hosts"

ansible_inventory_path = "ansible/inventory/group_vars/"

ansible_inventory_filename = "hosts.ini"
```
