# VPC ID on Development
output "dev_vpc_id" {
  description = "VPC ID on Development"
  value       = module.networking.vpc_id
}

# Public Subnets list ID on Development
output "dev_public_subnet_ids" {
  description = "Public Subnets list ID on Development"
  value       = module.networking.public_subnet_ids
}

# Private Subnets list ID on Development
output "dev_private_subnet_ids" {
  description = "Private Subnets list ID on Development"
  value       = module.networking.private_subnet_ids
}