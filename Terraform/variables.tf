variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

# VPC and subnet CIDRs
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# EKS Configuration
variable "cluster_name" {
  default     = "my-eks-cluster"
  description = "eks cluster name"
}

variable "desired_nodes" {
  default     = 2
}

variable "min_nodes" {
  default     = 1
}

variable "max_nodes" {
  default     = 3
}

variable "instance_types" {
  default     = ["t2.micro"]
}

# SSH key for worker nodes
variable "ssh_key_name" {
  description = "SSH key name for EC2 instances"
  default = "terraform"
}

# AMI ID for Jenkins EC2
variable "ami_id" {
  description = "The AMI ID to use for the Jenkins EC2 instance"
  default = "ami-0453ec754f44f9a4a"
  type        = string
}

# EC2 instance type
variable "instance_type" {
  description = "The instance type to use for Jenkins"
  default     = "t2.micro"
}

# Subnet ID
variable "subnet_id" {
  description = "The subnet ID where the Jenkins instance will be deployed"
  type        = string
}

# SSH key pair for access
variable "key_pair" {
  description = "The name of the SSH key pair for accessing the Jenkins EC2 instance"
  type        = string
  default = "terraform"
}

variable "aws_account_id" {
  description = "The AWS account ID to restrict access to the S3 bucket"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}