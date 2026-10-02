terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}


# 创建VPC
resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true 
  enable_dns_hostnames = true 

  tags = {
    Name = "three-tier-vpc"
  }
}

# 创建subnet
## 创建AZ_a的subnet
resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"   
  map_public_ip_on_launch = true   
  tags = {
    Name = "public_a"
  }
}

resource "aws_subnet" "app_private_a" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "app_private_a"
  }
}

resource "aws_subnet" "db_private_a" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.21.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "db_private_a"
  }
}


## 创建AZ_b的subnet
resource "aws_subnet" "public_b" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1a"   
  map_public_ip_on_launch = true   
  tags = {
    Name = "public_b"
  }
}

resource "aws_subnet" "app_private_b" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.12.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "app_private_b"
  }
}

resource "aws_subnet" "db_private_b" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.22.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "db_private_b"
  }
}


# 创建IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "three-tier-igw"
  }
}


# 创建Route Table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "three-tier-public-rt"
  }
}

## 创建public subnet的路由表中的条目

resource "aws_route" "public_internet" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"        
  gateway_id = aws_internet_gateway.igw.id   
}


## 创建app private路由表

resource "aws_route_table" "app_private" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "three-tier-app-private-rt"
  }
}

## 创建db private路由表
resource "aws_route_table" "db_private" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "three-tier-db-private-rt"
  }
}

# subnet / route table  association

resource "aws_route_table_association" "public_a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

## public_b subnet的关联
resource "aws_route_table_association" "public_b" {
  subnet_id = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

## app_private subnet的关联

resource "aws_route_table_association" "app_private_a" {
  subnet_id = aws_subnet.app_private_a.id
  route_table_id = aws_route_table.app_private.id
}
resource "aws_route_table_association" "app_private_b" {
  subnet_id = aws_subnet.app_private_b.id
  route_table_id = aws_route_table.app_private.id
}

## db_private subnet的关联

resource "aws_route_table_association" "db_private_a" {
  subnet_id = aws_subnet.db_private_a.id
  route_table_id = aws_route_table.db_private.id
}
resource "aws_route_table_association" "db_private_b" {
  subnet_id = aws_subnet.db_private_b.id
  route_table_id = aws_route_table.db_private.id
}
