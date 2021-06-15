# Required configuration

variable "vms" {}
variable "ssh_public_key" {}

# Optional configuration

variable "hcloud_location" {
  default = "fsn1"
}
variable "private_ip_range" {
  default = "10.10.0.0/16"
}
variable "ssh_public_key_name" {
  default = "default"
}
variable "private_network_name" {
  default = "default"
}
variable "private_network_zone" {
  default = "eu-central"
}
variable "floating_ip_name" {
  default = "default"
}
variable "volume_name" {
  default = "volume"
}
variable "volume_size" {
  default = "0"
}
variable "volume_filesystem" {
  default = "ext4"
}
variable "ansible_hostgroup_name" {
  defautl = "hosts"
}
variable "ansible_inventory_path" {
  default = "ansible/inventory/group_vars/"
}
variable "ansible_inventory_filename" {
  default = "hosts.ini"
}
variable "ansible_volumes_filename" {
  default = "volumes.yml"
}
