# Create an ECR repository
resource "aws_ecr_repository" "ecr_repo" {
  name = var.repository_name
  
  image_tag_mutability = "MUTABLE"  # Optional: Can be set to "IMMUTABLE" if you want to prevent image overwrites

  # Optional: Enforce image scanning on push
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = var.repository_name
    Environment = var.environment
  }
}
