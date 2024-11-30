# Variables related to the RDS instance
variable "vpc_id" {
  description = "The VPC ID where EKS will be deployed"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  default     = "mydb"
}

variable "db_username" {
  description = "The database username"
  default     = "admin"
}

variable "db_password" {
  description = "The database password"
  default     = "admin123"
}

variable "db_instance_class" {
  description = "The RDS instance class"
  default     = "db.t2.micro"
}

variable "db_allocated_storage" {
  description = "The allocated storage for the RDS instance (in GB)"
  default     = 20
}

variable "db_engine" {
  description = "The database engine"
  default     = "MySQL"
}

variable "db_version" {
  description = "The version of the database engine"
  default     = "8.0"
}

variable "private_subnets" {
  description = "List of private subnets where the RDS instance will be deployed"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}
