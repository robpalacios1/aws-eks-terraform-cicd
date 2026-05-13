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
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    
    tags = {
      Name = "public-subnet-1"
    }
}

# 3. Create Public Subnet (2)
resource "aws_subnet" "public-subnet-2" {
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
      Name = "public-subnet-2"
    }
}

# 4. Create Private Subnet (1)
resource "aws_subnet" "private-subnet-1" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}

# 5. Create Private Subnet (2)
resource "aws_subnet" "private-subnet-2" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
}

# 6. Create Internet Gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-igw"
  }
}

# 7. Create Elastic IP (1) 
resource "aws_eip" "nat-eip-az1" {
    domain = "vpc"

    tags = {
      Name = "nat-eip-az1"
      environment = "dev"
    }
    depends_on = [ aws_internet_gateway.main-igw ]
}

# 8. Create Elastic IP (2)
resource "aws_eip" "nat-eip-az2" {
    domain = "vpc"

    tags =  {
      Name = "nat-eip-az2"
      environment = "dev"
    }
    depends_on = [ aws_internet_gateway.main-igw ]
}

# 9. Create a NAT Gateway AZ1
resource "aws_nat_gateway" "nat-gw-az1" {
  allocation_id = aws_eip.nat-eip-az1.id
  subnet_id = aws_subnet.public-subnet-1.id

  tags = {
    Name = "nat-gw-az1"
    environment = "dev"
  }
  depends_on = [ aws_internet_gateway.main-igw ]
}

# 10. Create a NAT Gateway AZ2
resource "aws_nat_gateway" "nat-gw-az2" {
  allocation_id = aws_eip.nat-eip-az2.id
  subnet_id = aws_subnet.public-subnet-2.id

  tags = {
    Name = "nat-gw-az2"
    environment = "dev"
  }
  depends_on = [ aws_internet_gateway.main-igw ]
}

# 11. Create Public Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main-vpc.id
  
  tags = {
    Name = "public-rt"
    environment = "dev"
  }
}

# 12. Create Route
resource "aws_route" "public-default-igw" {
  route_table_id = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main-igw.id
}

# 13. Create Route Table Association 1
resource "aws_route_table_association" "public-rta-1" {
  subnet_id = aws_subnet.public-subnet-1.id
  route_table_id = aws_route.table.public-rt.id
}

# 14. Create Route Table Association 2
resource "aws_route_table_association" "public-rta-2" {
  subnet_id = aws_subnet.public-subnet-2.id
  route_table_id = aws_route.table.public-rt.id
}