data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_compute_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vsphere_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.disk_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "node" {

  name               = "${var.hostname}"
  # folder             = "${var.vsphere_folder}"
  resource_pool_id   = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id       = "${data.vsphere_datastore.datastore.id}"

  num_cpus           = "${var.node_num_cpus}"
  memory             = "${var.node_memory}"
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  network_interface {
      network_id = "${data.vsphere_network.network.id}"
  }

  disk {
      label = "disk0"
      size  = "${var.root_volume_size}"
  }

  clone {
      template_uuid = "${data.vsphere_virtual_machine.template.id}"

      customize {
        linux_options {
          host_name = "${var.hostname}"
          domain    = "${var.domain}"
        }
        network_interface {
        }
      }
  }

  provisioner "remote-exec" {
    connection = {
    type = "ssh"
    user = "${var.ssh_username}"
    password = "${var.ssh_password}"
  }
inline = [
<<EOT
  set -x
  NETWORK_INTERFACE=$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")
  echo "$(date "+%F %T") My default network is $NETWORK_INTERFACE"
  INITIAL_IP=$(/sbin/ip -f inet addr show dev $NETWORK_INTERFACE | grep -Po 'inet \K[\d.]+')
  CURRENT_IP=$INITIAL_IP
  while [[ "$INITIAL_IP" == "$CURRENT_IP" ]]; do
    echo "-------------------------"
    echo "$(date "+%F %T") My name is $HOSTNAME"
    echo "$(date "+%F %T") My IP address is $CURRENT_IP"
    sleep 30s
    CURRENT_IP=$(/sbin/ip -f inet addr show dev $NETWORK_INTERFACE | grep -Po 'inet \K[\d.]+')
    echo "-------------------------"
  done
  echo "$(date "+%F %T") My name is $HOSTNAME"
  echo "$(date "+%F %T") My IP address is $CURRENT_IP"
EOT
    ]
  }

}
