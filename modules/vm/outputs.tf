output "node_name" {
  value = "${var.hostname}"
}

output "public_ip" {
  value = "${vsphere_virtual_machine.node.default_ip_address}"
}
