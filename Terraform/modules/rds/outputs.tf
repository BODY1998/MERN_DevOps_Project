# Output the RDS endpoint
output "rds_endpoint" {
  description = "The RDS endpoint"
  value       = aws_db_instance.rds.endpoint
}

# Output the RDS security group
output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
