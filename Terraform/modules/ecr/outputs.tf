# Output the ECR repository name
output "ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.ecr_repo.name
}

# Output the ECR repository URI
output "ecr_repository_uri" {
  description = "The URI of the ECR repository"
  value       = aws_ecr_repository.ecr_repo.repository_url
}
