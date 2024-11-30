# Name for the Backup Vault
variable "backup_vault_name" {
  description = "The name of the backup vault"
  type        = string
}


# Name for the Backup Plan
variable "backup_plan_name" {
  description = "The name of the backup plan"
  type        = string
}

# Name for the Backup Rule
variable "backup_rule_name" {
  description = "The name of the backup rule"
  type        = string
}

# Cron schedule for backups
variable "backup_schedule" {
  description = "The cron expression for the backup schedule (e.g., daily at 5 AM UTC)"
  type        = string
}

# Retention period in days
variable "retention_days" {
  description = "The number of days to retain the backup"
  type        = number
  default     = 30  # Default retention is 30 days
}

# Name for the Backup Selection
variable "backup_selection_name" {
  description = "The name of the backup selection"
  type        = string
}

# Resources to back up (EC2 instance ARNs, etc.)
variable "backup_resources" {
  description = "List of ARNs of the resources to be backed up"
  type        = list(string)
}
