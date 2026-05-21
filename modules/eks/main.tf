# ====================================================================
# 1. ECR REPO (For Docker Images)
# ====================================================================

resource "aws_ecr_repository" "app_ecr_repo" {
  name                 = var.app_ecr_repo_name
  image_tag_mutability = var.app_ecr_image_mutability

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    environment = var.app_ecr_environment   
  }
}

# ====================================================================
# 2. CLUSTER EKS (Control Plane)
# ====================================================================

resource "aws_eks_cluster" "main_eks_cluster" {
  name    = var.main_eks_cluster_name   
  version = var.main_eks_cluster_version   

  # The ARN from Role created in the file iam.tf
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = var.main_eks_cluster_subnets_ids

    # Allow connect to cluster from your terminal (kubectl)
    endpoint_public_access  = var.main_eks_cluster_public_access    
    endpoint_private_access = var.main_eks_cluster_private_access
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}

# ====================================================================
# 3. NODES GROUP (Worker Nodes - Instances EC2)
# ====================================================================

resource "aws_eks_node_group" "main_eks_node_group" {
  cluster_name    = aws_eks_cluster.main_eks_cluster.name
  node_group_name = var.main_eks_node_group_name

  # We use the ARN of role for the nodes created in iam.tf 
  node_role_arn = aws_iam_role.node.arn

  subnet_ids = var.main_eks_node_group_subnets_ids

  capacity_type  = var.main_eks_node_group_capacity_type  
  instance_types = var.main_eks_node_group_instance_type

  # Auto Scaling Configuration
  scaling_config {
    desired_size = var.main_eks_node_group_desired_size
    max_size     = var.main_eks_node_group_max_size
    min_size     = var.main_eks_node_group_min_size
  }

  # Configuration Update without time of inactivity
  update_config {
    max_unavailable = var.main_eks_node_group_max_unavailable
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.node_cni_policy,
    aws_iam_role_policy_attachment.node_ecr_policy
  ]
}