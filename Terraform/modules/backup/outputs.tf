# Output the backup vault name
output "backup_vault_name" {
  description = "The name of the backup vault"
  value       = aws_backup_vault.backup_vault.name
}

# Output the backup plan ID
output "backup_plan_id" {
  description = "The ID of the backup plan"
  value       = aws_backup_plan.backup_plan.id
}
