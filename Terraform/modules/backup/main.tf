# Backup Vault for storing backups
resource "aws_backup_vault" "backup_vault" {
  name        = var.backup_vault_name
  tags = {
    Name = var.backup_vault_name
  }
}

# Backup Plan to define the backup schedule
resource "aws_backup_plan" "backup_plan" {
  name = var.backup_plan_name

  rule {
    rule_name         = var.backup_rule_name
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = var.backup_schedule  # Cron schedule for backups
    lifecycle {
      delete_after = var.retention_days  # Retain backups for X days
    }
  }

  tags = {
    Name = var.backup_plan_name
  }
}

# Backup Selection for selecting resources to back up
resource "aws_backup_selection" "backup_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = var.backup_selection_name
  plan_id = aws_backup_plan.backup_plan.id
  resources = var.backup_resources
}

# IAM Role for AWS Backup
resource "aws_iam_role" "backup_role" {
  name = "aws-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the necessary policy for AWS Backup
resource "aws_iam_role_policy_attachment" "backup_policy" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}
