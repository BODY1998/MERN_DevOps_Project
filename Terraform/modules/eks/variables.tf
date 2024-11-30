# Inputs to the EKS module

variable "vpc_id" {
  description = "The VPC ID where EKS will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "eks_sg" {
  description = "Security group for EKS"
}

variable "cluster_name" {
  description = "my-eks-cluster"
}

variable "desired_nodes" {
  description = "Desired number of nodes in the worker group"
  default     = 2
}

variable "min_nodes" {
  description = "Minimum number of nodes in the worker group"
  default     = 1
}

variable "max_nodes" {
  description = "Maximum number of nodes in the worker group"
  default     = 3
}

variable "instance_types" {
  description = "The instance types for the worker nodes"
  default     = ["t2.micro"]
}

#----------------------------------------------------------------

# Worker nodes AMI
variable "worker_ami_id" {
  description = "AMI ID for the EKS worker nodes"
  default = "ami-0166fe664262f664c"
}

# SSH key for worker nodes
variable "ssh_key_name" {
  description = "SSH key name for EC2 instances"
  default = "terraform"
}
