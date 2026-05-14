# create variable Cluster Name
variable "cluster_name" {
  description = "Base name for the Cluster and its resources"
  type = string
  default = "development-eks-cluster-role"
}

# create variable Node Name
variable "node_name" {
  description = "Base name for the Node and its resources"
  type = string
  default = "development-eks-node-role"
}