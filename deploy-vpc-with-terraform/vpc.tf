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

# ---- three-tier-vpc ---- #
resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "three-tier-vpc"
  }
}


# ---- AZ_a---- #

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
  cidr_block = "10.0.12.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "db_private_a"
  }
}


# ---- AZ_b---- #

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
  cidr_block = "10.0.21.0/24"
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
