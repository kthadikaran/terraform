terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "default"
}

locals {
  common_tags = {
    Name        = "stopnshop-webserver${count.index}"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}
#Create New VPC with Subnet, RoteTable, Internet gateway, Security Group, NACL and Instances.

#Create VPC
resource "aws_vpc" "stopnshop-prod-vpc" {
  cidr_block           = var.vpccidrip
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "stopnshop-prod-vpc"
    Project     = "stopnshop"
    Environment = "production"
    Owner       = "kthadikaran@gmail.com"
  }
}

#Create Network Access Control List for additional security of VPC 
resource "aws_default_network_acl" "stopnshop-prod-vpc-nacl" {
  default_network_acl_id = aws_vpc.stopnshop-prod-vpc.default_network_acl_id
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 61000
  }


  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name        = "stopnshop-prod-vpc-nacl"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}

#Create VPC InternetGateway
resource "aws_internet_gateway" "stopnshop-prod-igw" {
  vpc_id = aws_vpc.stopnshop-prod-vpc.id

  tags = local.common_tags
}
