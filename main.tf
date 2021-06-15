# add ssh key to hcloud project to connect to nodes with ansible later on
resource "hcloud_ssh_key" "default" {
  name       = var.ssh_public_key_name
  public_key = file(var.ssh_public_key)
}

# create private network
resource "hcloud_network" "default" {
  name     = var.private_network_name
  ip_range = var.private_ip_range
}

# create subnet
resource "hcloud_network_subnet" "default" {
  network_id   = hcloud_network.default.id
  type         = "server"
  network_zone = var.private_network_zone
  ip_range     = var.private_ip_range
}

# provision worker nodes
resource "hcloud_server" "vms" {
  for_each = var.vms

  name        = each.value.name
  image       = each.value.image
  server_type = each.value.server_type
  location    = each.value.location
  backups     = each.value.backups
  ssh_keys    = [var.ssh_public_key_name]

  depends_on = [
    hcloud_network_subnet.default,
    hcloud_ssh_key.default
  ]
}

# configure reverse dns for IPv4
resource "hcloud_rdns" "rdnsipv4" {
  for_each = var.vms

  server_id  = hcloud_server.vms[each.key].id
  ip_address = hcloud_server.vms[each.key].ipv4_address
  dns_ptr    = hcloud_server.vms[each.key].name

  depends_on = [
    hcloud_server.vms
  ]
}

# configure reverse dns for IPv6
resource "hcloud_rdns" "rdnsipv6" {
  for_each = var.vms

  server_id  = hcloud_server.vms[each.key].id
  ip_address = hcloud_server.vms[each.key].ipv6_address
  dns_ptr    = hcloud_server.vms[each.key].name

  depends_on = [
    hcloud_server.vms
  ]
}

# connect vms to private network
resource "hcloud_server_network" "private_network" {
  for_each = var.vms

  network_id = hcloud_network.default.id
  server_id  = hcloud_server.vms[each.key].id
  ip         = each.value.private_ip_address

  depends_on = [
    hcloud_server.vms,
    hcloud_network_subnet.default
  ]
}

# add volume to server
resource "hcloud_volume" "master" {
  for_each = var.vms

  name = var.volume_name
  size = var.volume_size
  server_id = hcloud_server.vms[each.key].id
  automount = true
  format = var.volume_filesystem

  depends_on = [
    hcloud_server.vms
  ]
}

# generate inventory file for ansible
resource "local_file" "hosts" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      vms = hcloud_server.vms
    }
  )
  filename = "${var.ansible_inventory_path}/${var.ansible_inventory_filename}"
}

# generate variable file for ansible
resource "local_file" "volume" {
  content = templatefile("${path.module}/templates/volume_linux_device.tpl",
    {
      volumes = hcloud_volume.master
    }
  )
  filename = "${var.ansible_inventory_path}/${var.ansible_volumes_filename}"
}
