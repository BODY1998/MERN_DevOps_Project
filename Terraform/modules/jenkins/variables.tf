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

# VPC ID
variable "vpc_id" {
  description = "The VPC ID where the Jenkins instance will be deployed"
  type        = string
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
