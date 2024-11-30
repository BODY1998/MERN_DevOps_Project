# Repository name for ECR
variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

# Environment (e.g., dev, prod)
variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}