# Output the S3 bucket name where ALB logs are stored
output "alb_access_log_bucket_name" {
  description = "The name of the S3 bucket where ALB access logs are stored"
  value       = aws_s3_bucket.alb_access_log_bucket.bucket
}

# Output the ALB DNS name (from the EKS module or ALB configuration)
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.example.dns_name
}
