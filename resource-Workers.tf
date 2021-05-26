//Creating  Virtual Machines as worker nodes
resource "vsphere_virtual_machine" "vm-Worker" {
  count            = var.vmWorkerCount
  name             = "${var.vmWorkerName}${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vmWorkerCpu
  memory   = var.vmWorkerRam
  guest_id = data.vsphere_virtual_machine.template.guest_id
  folder   = var.vmFolder
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label            = "${var.vmWorkerName}${count.index + 1}.vmdk"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.vmWorkerName}${count.index + 1}"
        domain    = var.vmDomain
      }
      ipv4_gateway    = var.vmGw
      dns_server_list = [var.vmDns]
      network_interface {
        ipv4_address = "${var.vmWorkerNetwork}${"${var.vmWorkerHost}" + count.index + 1}"
        ipv4_netmask = var.vmPrefix
      }
    }
  }

  //--------------------------------------------------
  //Install kubeadm,kubelet and kubectl on worker nodes
  provisioner "remote-exec" {
    inline = [
      "yum install -y  kubelet-${var.k8sVersion} kubeadm-${var.k8sVersion} kubectl-${var.k8sVersion} --disableexcludes=kubernetes",
      "systemctl enable kubelet",
      "systemctl start kubelet",
    ]
    connection {
      type     = "ssh"
      user     = "root"
      password = var.vmPassword
      host     = "${var.vmWorkerNetwork}${"${var.vmWorkerHost}" + count.index + 1}"
    }
  }

  //------------------------------------------------------
  // Copy token file from terraform server to worker nodes
  provisioner "file" {
    source      = "/tmp/kubeadm-token.sh"
    destination = "/tmp/kubeadm-token.sh"

    connection {
      type     = "ssh"
      user     = "root"
      password = var.vmPassword
      host     = "${var.vmWorkerNetwork}${"${var.vmWorkerHost}" + count.index + 1}"
    }
  }

  //-----------------------------------------------
  // run Kubeadm join token command on worker nodes for joining to k8s cluster
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/kubeadm-token.sh",
      "/tmp/kubeadm-token.sh"
    ]
    connection {
      type     = "ssh"
      user     = "root"
      password = var.vmPassword
      host     = "${var.vmWorkerNetwork}${"${var.vmWorkerHost}" + count.index + 1}"
    }
  }

  //-----------------------------------------------
  // Define priority to create worker nodes after creating master node
  depends_on = [
    "vsphere_virtual_machine.vm-Master",
  ]
}
