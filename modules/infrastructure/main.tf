# 1. Create VPC
resource "aws_vpc" "main-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "main-vpc"
        environment = "dev"
    }
}

# 2. Create Public Subnets (1)
resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.main-vpc
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    
    tags = {
      Name = "public-subnet-1"
    }
}

# 3. Create Public Subnet (2)
resource "aws_subnet" "public-subnet-2" {
    vpc_id = aws_vpc.main-vpc
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
      Name = "public-subnet-2"
    }
}