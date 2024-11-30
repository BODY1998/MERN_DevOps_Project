# Create S3 bucket to store ALB access logs
resource "aws_s3_bucket" "alb_access_log_bucket" {
  bucket = var.alb_access_log_bucket_name
  tags = {
    Name        = var.alb_access_log_bucket_name
    Environment = var.environment
  }
}

# Optional: Attach a bucket policy to ensure that only ALB can write logs to this bucket
resource "aws_s3_bucket_policy" "alb_access_log_bucket_policy" {
  bucket = aws_s3_bucket.alb_access_log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowALBLogDelivery",
        Effect    = "Allow",
        Principal = {
          Service = "elasticloadbalancing.amazonaws.com"
        },
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.alb_access_log_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "aws:SourceAccount": "${var.aws_account_id}"
          },
          ArnLike = {
            "aws:SourceArn": "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:loadbalancer/*"
          }
        }
      }
    ]
  })
}

# Enable access logs on the ALB (Application Load Balancer)
resource "aws_lb" "example" {
  # You should pass the ALB ID from your EKS module to this logging module
  name               = var.alb_name  # Assume ALB is created in EKS module
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = var.alb_subnets

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.alb_access_log_bucket.id
    prefix  = var.alb_log_prefix  # Optional prefix for log files in S3
    enabled = true
  }
}
