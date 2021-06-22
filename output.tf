output "virtual_server_public_ipv4" {
  value = {
    for vm in hcloud_server.vms :
    vm.name => vm.ipv4_address
  }
  description = "Show public IPv4 addresses of all virtual servers."
}
output "virtual_server_public_ipv6" {
  value = {
    for vm in hcloud_server.vms :
    vm.name => vm.ipv6_address
  }
  description = "Show public IPv6 addresses of all virtual servers."
}
output "virtual_server_private_ipv4" {
  value = {
    for vm in hcloud_server.vms :
    vm.name => vm.network.*.ip
  }
  description = "Show private IPv4 addresses of all virtual servers."
}
