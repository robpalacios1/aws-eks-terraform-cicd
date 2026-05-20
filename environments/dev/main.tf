module "networking" {
  source = "../../modules/networking"
 
# ====================================================================
# 1. variables for networking module
# ====================================================================

  # VPC
  vpc_cidr_block  = "10.0.0.0/16"
  vpc_name        = "development"
  vpc_environment = "dev"

  # public Subnet 1
  public_subnet_1_cidr_block = "10.0.1.0/24"
  public_subnet_1_az1a       = "us-east-1a"
  public_subnet_1_name       = "public-subnet-1"

  # public Subnet 2
  public_subnet_2_cidr_block = "10.0.2.0/24"
  public_subnet_2_az1b       = "us-east-1b"
  public_subnet_2_name       = "public-subnet-2"

  # private Subnet 1
  private_subnet_1_cidr_block = "10.0.3.0/24"
  private_subnet_1_az1a       = "us-east-1a"
  private_subnet_1_name       = "private-subnet-1"

  # private Subnet 2
  private_subnet_2_cidr_block = "10.0.4.0/24"
  private_subnet_2_az1b       = "us-east-1b"
  private_subnet_2_name       = "private-subnet-2"

  # Internet Gatewy
  igw_name = "main-igw"

  # Elastic IP (1)
  nat_eip_az1_name = "nat-eip-az1"

  # Elastic IP (2)
  nat_eip_az2_name = "nat-eip-az2"

  # NAT Gateway AZ1
  nat_gw_az1_name = "nat-gw-az1"

  # NAT Gateway AZ2
  nat_gw_az2_name = "nat-gw-az2"

  # Public Route Table
  public_rt_name = "public-rt"

  # Destination cidr block
  public_destination_cidr_block = "0.0.0.0/0"

  # Private Route Table AZ1
  private_rt_az1_name = "private-rt-az1"

  # Private Route Table AZ2
  private_rt_az2_name = "private-rt-az2"
}

///////////////////////////////////////////////////////////////////////
module "eks" {
  source = "../../modules/eks"

# ====================================================================
# 2. variables for EKS module
# ====================================================================

  #Cluster Name
  cluster_name = "development-eks-cluster-role"
  node_name = "development-eks-node-role"

  # ECR Repo
  app_ecr_repo_name = "development-app-ecr-repo"
  app_ecr_image_mutability = "MUTABLE"
  app_ecr_environment = "dev"

  # Cluster EKS
  main_eks_cluster_name = "development-eks-cluster"
  main_eks_cluster_version = "1.30"
  main_eks_cluster_subnets_ids = module.networking.dev_private_subnets_ids
  main_eks_cluster_public_access = true
  main_eks_cluster_private_access = false

  # Node Groups
  main_eks_node_group_name = "development-eks-node-group"
  main_eks_node_group_subnets_ids = module.networking.dev_private_subnets_ids
  main_eks_node_group_desired_size = 2
  main_eks_node_group_max_size = 3
  main_eks_node_group_min_size = 1
  main_eks_node_group_max_unavailable = 1
}