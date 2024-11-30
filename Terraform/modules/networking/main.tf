# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets_cidr[count.index]
  map_public_ip_on_launch = true
}

# Private subnets
resource "aws_subnet" "private" {
  count      = length(var.private_subnets_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnets_cidr[count.index]
}

# Security group for EKS
resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}