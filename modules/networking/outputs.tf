# VPC ID
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main-vpc.id
}

# Public Subnets list ID
output "public_subnet_ids" {
  description = "Public Subnets list ID"
  value = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]
}

# Private Subnets list ID
output "private_subnet_ids" {
  description = "Private Subnets list ID"
  value = [
    aws_subnet.private-subnet-1.id,
    aws_subnet.private-subnet-2.id
  ]
}