# S3 bucket name for ALB access logs
variable "alb_access_log_bucket_name" {
  description = "The name of the S3 bucket to store ALB access logs"
  type        = string
}

# AWS account ID
variable "aws_account_id" {
  description = "The AWS account ID to restrict access to the S3 bucket"
  type        = string
  default = "529088271294"
}

# Optional prefix for logs in the S3 bucket
variable "alb_log_prefix" {
  description = "The optional prefix for the ALB access logs in the S3 bucket"
  type        = string
  default     = ""
}

# ALB name (to reference the existing ALB from the EKS module)
variable "alb_name" {
  description = "The name of the ALB (created in the EKS module)"
  type        = string
}

# ALB security groups (inherited from EKS module)
variable "alb_security_groups" {
  description = "The security groups for the ALB"
  type        = list(string)
}

# ALB subnets (inherited from the networking or EKS module)
variable "alb_subnets" {
  description = "The subnets for the ALB"
  type        = list(string)
}

# Environment (for tagging)
variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}
