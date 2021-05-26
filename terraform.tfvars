// Variables with value of Vcenter
vcenterIp = "172.17.3.121"
vcenterMapUsername = {
  "172.17.3.121" = "administrator@vsphere.local"
}
vcenterMapPassword = {
  "172.17.3.121" = "Aa@123456"
}
vcenterMapDatacenter = {
  "172.17.3.121" = "Datacenter"
}
vcenterMapDatastore = {
  "172.17.3.121" = "UNITY-LUN-1"
}
vcenterMapCluster = {
  "172.17.3.121" = "Cluster1"
}

//-----------------------------------------------
// Variables with value of Master Virtual Machine
vmMasterName = "k8s-master-1"
vmMasterIp   = "172.17.21.71"
vmMasterCpu  = 4
vmMasterRam  = 4096

//-----------------------------------------------
// Variables with value of worker Virtual Machine
vmWorkerName    = "k8s-worker-"
vmWorkerNetwork = "172.17.21."
vmWorkerHost    = 80
vmWorkerCpu     = 6
vmWorkerRam     = 8192
vmWorkerCount   = 3

//-------------------------------------------
# Shared Variables between master and worker nodes
vcenterNetwork  = "siraf-cluster"
vmPrefix        = "26"
vmGw            = "172.17.21.65"
vmDomain        = "mng.paas"
vmDns           = "172.17.21.132"
vmFolder        = "terraform-k8s-cluster"
vcenterTemplate = "template-centos-k8s-2"
vmPassword      = "Aa@123456"

//-----------------------------------------------
// Values for k8s cluster
k8sVersion     = "1.21.1"
k8sNetworkCidr = "10.244.0.0/16"