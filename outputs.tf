output "hostname" {
  value = "${var.hostname}"
}

output "public_ip" {
  value = "${module.vm.public_ip}"
}
