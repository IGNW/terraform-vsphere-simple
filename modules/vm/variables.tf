variable "vsphere_datacenter" {
  description = "The vSphere datacenter in which to create the virtual machine"
}

variable "vsphere_datastore" {
  description = "vSphere datastore to use"
}

variable "vsphere_compute_cluster" {
  description = "vSphere compute cluster to use"
}

variable "vsphere_network" {
  description = "vSphere network to use"
}

variable "vsphere_folder" {
  description = "The vsphere folder in which to place the virtual machine"
}

variable "hostname" {
  description = "The host name for this node"
}

variable "domain" {
  description = "Domain name for this node"
}

variable "node_num_cpus" {
  description = "Virtual CPUs to configure for this node"
}

variable "node_memory" {
  description = "Memory in MB to configure for this node"
}

variable "root_volume_size" {
  description = "The size of the root volume in gigabytes."
}

variable "disk_template" {
  description = "vSphere template to use as a disk template"
}

variable "ssh_username" {
}

variable "ssh_password" {
}
