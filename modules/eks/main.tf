# ====================================================================
# 1. ECR REPO (For Docker Images)
# ====================================================================

resource "aws_ecr_repository" "app_ecr_repo" {
  name = "development-app-ecr-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    environment = "dev"
  }
}

# ====================================================================
# 2. CLUSTER EKS (Control Plane)
# ====================================================================

resource "aws_eks_cluster" "main_eks_cluster" {
  name = "development-eks-cluster"
  version = "1.30"

  # The ARN from Role created in the file iam.tf
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = [
        "subnet-0123456789abcdef0",
        "subnet-0abcdef1234567890"
    ]
    # Allow connect to cluster from your terminal (kubectl)
    endpoint_public_access = true
    endpoint_private_access = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}

# ====================================================================
# 3. NODES GROUP (Worker Nodes - Instances EC2)
# ====================================================================

resource "aws_eks_node_group" "main_eks_node_group" {
  cluster_name = aws_eks_cluster.main_eks_cluster.name
  node_group_name = "development-eks-node-group"
  
# We use the ARN of role for the nodes created in iam.tf 
  node_role_arn = aws_iam_role.node.arn

  subnet_ids = [
    "subnet-0123456789abcdef0",
    "subnet-0abcdef1234567890"
  ]

  capacity_type = "ON_DEMAND"
  instance_types = ["t3.micro"]
  
# Auto Scaling Configuration
  scaling_config {
    desired_size = 2
    max_size = 3
    min_size = 1
  }

# Configuration Update without time of inactivity
  update_config {
   max_unavailable = 1 
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.node_cni_policy,
    aws_iam_role_policy_attachment.node_ecr_policy
  ]
}