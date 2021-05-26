//Creating a Virtual Machine as a k8s master server
resource "vsphere_virtual_machine" "vm-Master" {
  name             = var.vmMasterName
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vmMasterCpu
  memory   = var.vmMasterRam
  guest_id = data.vsphere_virtual_machine.template.guest_id
  folder   = var.vmFolder
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label            = "${var.vmMasterName}.vmdk"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = var.vmMasterName
        domain    = var.vmDomain
      }
      ipv4_gateway    = var.vmGw
      dns_server_list = [var.vmDns]
      network_interface {
        ipv4_address = var.vmMasterIp
        ipv4_netmask = var.vmPrefix
      }
    }
  }

  //-----------------------------------------------
  //Install kubernetes service, Luanch k8s cluster with kubeadm, Create weavenet network on the cluster
  provisioner "remote-exec" {
    inline = [
      "yum install -y  kubelet-${var.k8sVersion} kubeadm-${var.k8sVersion} kubectl-${var.k8sVersion} --disableexcludes=kubernetes",
      "systemctl enable kubelet",
      "systemctl start kubelet",
      "kubeadm init --pod-network-cidr=${var.k8sNetworkCidr}",
      "mkdir -p $HOME/.kube;sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config;sudo chown $(id -u):$(id -g) $HOME/.kube/config",
      "kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')\"",
      "kubeadm token create --print-join-command > /tmp/kubeadm-token.sh",
      "kubectl get node",
    ]
    connection {
      type     = "ssh"
      user     = "root"
      password = var.vmPassword
      host     = var.vmMasterIp
    }
  }

  //-----------------------------------------------
  //Copy join token from master server to terraform server
  provisioner "local-exec" {
    command = "/usr/bin/sshpass -p \"Aa@123456\" scp -o StrictHostKeyChecking=no root@${var.vmMasterIp}:/tmp/kubeadm-token.sh /tmp/kubeadm-token.sh"
  }
}