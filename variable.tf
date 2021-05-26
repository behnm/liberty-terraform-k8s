// Variable of Vcneter
variable "vcenterIp" {
  description = "Vcenter IP address"
  type        = string
}
variable "vcenterMapDatacenter" {
  description = "Datacenter defined in the Vcenter"
  type        = map(any)
}
variable "vcenterMapDatastore" {
  description = "Datastore that the VM will be created on"
  type        = map(any)
}
variable "vcenterMapCluster" {
  description = "Cluster of the vcenter"
  type        = map(any)
}
variable "vcenterMapUsername" {
  description = "Vcenter Username"
  type        = map(any)
}
variable "vcenterMapPassword" {
  description = "Vcenter password"
  type        = map(any)
}

//-------------------------------------------
//Variables of Master Virtual Machine
variable "vmMasterName" {
  description = "Master VM name"
  type        = string
}
variable "vmMasterIp" {
  description = "Master VM IP address"
  type        = string
}
variable "vmMasterCpu" {
  description = "Master VM CPU (vCore)"
  type        = number
}
variable "vmMasterRam" {
  description = "Msater VM RAM (MB)"
  type        = number
}

//-------------------------------------------
# Variables of Worker virtual machines
variable "vmWorkerName" {
  description = "wporker VM name"
  type        = string
}
variable "vmWorkerNetwork" {
  description = "Worker VM Netrwork"
  type        = string
}
variable "vmWorkerHost" {
  description = "Worker VM host IP address"
  type        = number
}
variable "vmWorkerCpu" {
  description = "worker VM CPU (vCore)"
  type        = number
}
variable "vmWorkerRam" {
  description = "worker VM RAM (MB)"
  type        = number
}
variable "vmWorkerCount" {
  description = "Number of Workers"
  type        = number
}

//-------------------------------------------
# Shared Variables between master and worker nodes
variable "vcenterNetwork" {
  description = "The network which the VM will be created on"
  type        = string
}
variable "vcenterTemplate" {
  description = "The template which the VM will be created with"
  type        = string
}

variable "vmPrefix" {
  description = "VM IP Prefix"
  type        = string
}
variable "vmGw" {
  description = "VM Network Gateway"
  type        = string
}
variable "vmDomain" {
  description = "VM network domain name"
  type        = string
}
variable "vmFolder" {
  description = "The folder which VM will be created in"
  type        = string
}
variable "vmDns" {
  description = "VM dns IP addresses"
  type        = string
}
variable "vmPassword" {
  description = "VM password"
  type        = string
}

//-------------------------------------------
# Kubernetes Variables
variable "k8sVersion" {
  description = "Kubelet, kubeadm and kubectl tools version"
  type        = string
}
variable "k8sNetworkCidr" {
  description = "Network weavenet CIDR"
  type        = string
}

