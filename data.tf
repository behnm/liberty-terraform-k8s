// Data gathers for Vcenter provider
data "vsphere_datacenter" "dc" {
  name = lookup(var.vcenterMapDatacenter, var.vcenterIp)
}
data "vsphere_datastore" "datastore" {
  name          = lookup(var.vcenterMapDatastore, var.vcenterIp)
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = lookup(var.vcenterMapCluster, var.vcenterIp)
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vcenterNetwork
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vcenterTemplate
  datacenter_id = data.vsphere_datacenter.dc.id
}