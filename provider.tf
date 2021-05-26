// Define Vcenter Provider 
provider "vsphere" {
  user                 = lookup(var.vcenterMapUsername, var.vcenterIp)
  password             = lookup(var.vcenterMapPassword, var.vcenterIp)
  vsphere_server       = var.vcenterIp
  allow_unverified_ssl = true
}