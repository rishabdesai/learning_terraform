terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "My-VPC-vpc"
  }
}

# Public subnet
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "My-VPC-subnet-public1-us-east-1a"
  }
}

# Private subnet
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "My-VPC-subnet-private1-us-east-1a"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My-VPC-igw"
  }
}

# Public route table
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My-VPC-rtb-public"
  }
}

# Route to IGW for public route table
resource "aws_route" "public_default_route" {
  route_table_id         = aws_route_table.rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate public route table with public subnet
resource "aws_route_table_association" "assoc_public_subnet" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.rtb_public.id
}

# Private route table
resource "aws_route_table" "rtb_private_1" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My-VPC-rtb-private1-us-east-1a"
  }
}

# Associate private route table with private subnet
resource "aws_route_table_association" "assoc_private_subnet_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.rtb_private_1.id
}
