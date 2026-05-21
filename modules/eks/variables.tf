//////////////////////////////////////////////////////
# create variable Cluster Name
variable "cluster_name" {
  description = "Base name for the Cluster and its resources"
  type        = string
  default     = "development-eks-cluster-role"
}

# create variable Node Name
variable "node_name" {
  description = "Base name for the Node and its resources"
  type        = string
  default     = "development-eks-node-role"
}

//////////////////////////////////////////////////////
# Create variables for ECR REPO

variable "app_ecr_repo_name" {
  description = "Name of ECR Repo on development environment"
  type = string 
  default = "development-app-ecr-repo"
}

variable "app_ecr_image_mutability" {
  description = "Image mutability"
  type = string 
  default = "MUTABLE"
}

variable "app_ecr_environment" {
  description = "The environment to deploy infrastructure"
  type        = string
  default     = "dev"
}

//////////////////////////////////////////////////////
# Create variables for Cluster EKS

variable "main_eks_cluster_name" {
  description = "Name of EKS Cluster on development environment"
  type = string
  default = "development-eks-cluster"
}

variable "main_eks_cluster_version" {
  description = "Version EKS Cluster"
  type = string
  default = "1.35"
}

variable "main_eks_cluster_subnets_ids" {
  description = "Subnets ID's"
  type = list(string)
}

variable "main_eks_cluster_public_access" {
  description = "Public Access"
  type = bool
  default = true
}

variable "main_eks_cluster_private_access" {
  description = "Public Access"
  type = bool
  default = false
}

//////////////////////////////////////////////////////
# Create variables for Nodes Group

variable "main_eks_node_group_name" {
  description = "Name of EKS Node Group on development environment"
  type = string
  default = "development-eks-node-group"
}

variable "main_eks_node_group_subnets_ids" {
  description = "Subnets ID's"
  type = list(string)
}

variable "main_eks_node_group_desired_size" {
  description = "Scaling Config in desired Size"
  type = number
  default = 3
}

variable "main_eks_node_group_max_size" {
  description = "Scaling Config in Max Size"
  type = number
  default = 3
}

variable "main_eks_node_group_min_size" {
  description = "Scaling Config in Min Size"
  type = number
  default = 1
}

variable "main_eks_node_group_max_unavailable" {
  description = "Time of inactivity"
  type = number
  default = 1
}