# 1. Create VPC
resource "aws_vpc" "main-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name        = var.vpc_name
    environment = var.vpc_environment
  }
}

# 2. Create Public Subnets (1)
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.public_subnet_1_cidr_block
  availability_zone       = var.public_subnet_1_az1a
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_1
  }
}

# 3. Create Public Subnet (2)
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.public_subnet_2_cidr_block
  availability_zone       = var.public_subnet_2_az1b
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_2
  }
}

# 4. Create Private Subnet (1)
resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.private_subnet_1_cidr_block
  availability_zone = var.private_subnet_1_az1a
}

# 5. Create Private Subnet (2)
resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.private_subnet_2_cidr_block
  availability_zone = var.public_subnet_2_az1b
}

# 6. Create Internet Gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = var.igw_name
  }
}

# 7. Create Elastic IP (1) 
resource "aws_eip" "nat-eip-az1" {
  domain = "vpc"

  tags = {
    Name        = var.nat_eip_az1_name
    environment = var.vpc_name
  }
  depends_on = [aws_internet_gateway.main-igw]
}

# 8. Create Elastic IP (2)
resource "aws_eip" "nat-eip-az2" {
  domain = "vpc"

  tags = {
    Name        = var.nat_eip_az2_name
    environment = var.vpc_name
  }
  depends_on = [aws_internet_gateway.main-igw]
}

# 9. Create a NAT Gateway AZ1
resource "aws_nat_gateway" "nat-gw-az1" {
  allocation_id = aws_eip.nat-eip-az1.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name        = var.nat_gw_az1_name
    environment = var.vpc_name
  }
  depends_on = [aws_internet_gateway.main-igw]
}

# 10. Create a NAT Gateway AZ2
resource "aws_nat_gateway" "nat-gw-az2" {
  allocation_id = aws_eip.nat-eip-az2.id
  subnet_id     = aws_subnet.public-subnet-2.id

  tags = {
    Name        = var.nat_gw_az2_name
    environment = var.nat_gw_az2_name
  }
  depends_on = [aws_internet_gateway.main-igw]
}

# 11. Create Public Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name        = var.public_rt_name
    environment = var.vpc_name
  }
}

# 12. Create Route
resource "aws_route" "public-default-igw" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = var.public_destination_cidr_block
  gateway_id             = aws_internet_gateway.main-igw.id
}

# 13. Create Public Route Table Association 1
resource "aws_route_table_association" "public-rta-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}

# 14. Create Public Route Table Association 2
resource "aws_route_table_association" "public-rta-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-rt.id
}

# 15. Private Route Table AZ1 
resource "aws_route_table" "private-rt-az1" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name        = var.private_rt_az1_name
    environment = var.vpc_name
  }
}

# 16. Create private NAT AZ1
resource "aws_route" "private-default-nat-az1" {
  route_table_id         = aws_route_table.private-rt-az1.id
  destination_cidr_block = var.public_destination_cidr_block
  nat_gateway_id         = aws_nat_gateway.nat-gw-az1.id
}

# 17. Create private route table association in AZ1
resource "aws_route_table_association" "private-rta-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rt-az1.id
}

# 18. Private Route Table AZ2
resource "aws_route_table" "private-rt-az2" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name        = var.private_rt_az2_name
    environment = var.vpc_name
  }
}

# 19. Create private NAT AZ2
resource "aws_route" "private-default-nat-az2" {
  route_table_id         = aws_route_table.private-rt-az2.id
  destination_cidr_block = var.public_destination_cidr_block
  nat_gateway_id         = aws_nat_gateway.nat-gw-az2.id
}

# 20. Create private route table association in AZ2
resource "aws_route_table_association" "private-rt-az2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-rt-az2.id
}
