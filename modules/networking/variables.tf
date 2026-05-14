# Create Variables for VPC
variable "vpc_cidr_block" {
  description = "The CIDR Block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type = string
  default = "dev"
}

variable "vpc_environment" {
  description = "The environment to deploy infrastructure"
  type = string
  default = "dev"
}

////////////////////////////////////////////////////////////
# Create variables for public Subnet 1
variable "public_subnet_1_cidr_block" {
  description = "The CIDR Block for public subnet 1"
  type = string
  default = "10.0.1.0/24"
}

variable "public_subnet_1_az1a" {
  description = "The availability zone for public subnet 1"
  type = string
  default = "us-east-1a"
}

variable "public_subnet_1" {
  description = "The public subnet 1 name"
  type = string
  default = "public-subnet-1"
}

////////////////////////////////////////////////////////////
# Create variables for public Subnet 2
variable "public_subnet_2_cidr_block" {
  description = "The CIDR Block for public subnet 2"
  type = string
  default = "10.0.2.0/24"
}

variable "public_subnet_2_az1b" {
  description = "The availability zone for public subnet 2"
  type = string
  default = "us-east-1b"
}

variable "public_subnet_2" {
  description = "The public subnet 2 name"
  type = string
  default = "public-subnet-2"
}

////////////////////////////////////////////////////////////
# Create variables for private Subnet 1
variable "private_subnet_1_cidr_block" {
  description = "The CIDR Block for private subnet 1"
  type = string
  default = "10.0.3.0/24"
}

variable "private_subnet_1_az1a" {
  description = "The availability zone for private subnet 1"
  type = string
  default = "us-east-1a"
}

////////////////////////////////////////////////////////////
# Create variables for private Subnet 2
variable "private_subnet_2_cidr_block" {
  description = "The CIDR Block for private subnet 2"
  type = string
  default = "10.0.4.0/24"
}

variable "private_subnet_2_az1b" {
  description = "The availability zone for private subnet 2"
  type = string
  default = "us-east-1b"
}

////////////////////////////////////////////////////////////
# Create variables for Internet Gateway
variable "igw_name" {
  description = "Internet Gatewat name"
  type = string
  default = "main-igw"
}

////////////////////////////////////////////////////////////
# Create variables for Elastic IP (1)
variable "nat_eip_az1_name" {
  description = "Name of Elastic IP in availability zone 1"
  type = string
  default = "nat-eip-az1"
}

////////////////////////////////////////////////////////////
# Create variables for Elastic IP (2)
variable "nat_eip_az2_name" {
  description = "Name of Elastic IP in availability zone 2"
  type = string
  default = "nat-eip-az2"
}

////////////////////////////////////////////////////////////
# Create variables for NAT Gateway AZ1
variable "nat_gw_az1_name" {
  description = "Name of NAT Gateway in availability zone 1"
  type = string
  default = "nat-gw-az1"
}

////////////////////////////////////////////////////////////
# Create variables for NAT Gateway AZ1
variable "nat_gw_az2_name" {
  description = "Name of NAT Gateway in availability zone 2"
  type = string
  default = "nat-gw-az2"
}

////////////////////////////////////////////////////////////
# Create variables for Public Route Table
variable "public_rt_name" {
  description = "Name of public route table"
  type = string
  default = "public-rt"
}

////////////////////////////////////////////////////////////
# Create variables for destination cidr block
variable "public_destination_cidr_block" {
  description = "destination_cidr_block"
  type = string
  default = "0.0.0.0/0"
}

////////////////////////////////////////////////////////////
# Create variables for Private Route Table AZ1
variable "private_rt_az1_name" {
  description = "Name of Private Route Table in availability zone 1"
  type = string
  default = "private-rt-az1"
}

////////////////////////////////////////////////////////////
# Create variables for Private Route Table AZ2
variable "private_rt_az2_name" {
  description = "Name of Private Route Table in availability zone 2"
  type = string
  default = "private-rt-az2"
}