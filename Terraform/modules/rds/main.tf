# Create RDS instance
resource "aws_db_instance" "rds" {
  identifier             = "my-rds-instance"
  engine                 = var.db_engine
  engine_version         = var.db_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # Ensure the database is deployed in private subnets
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true
}

# Create a DB subnet group for the RDS instance
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "RDS Subnet Group"
  }
}

# Security group for RDS allowing access from specific instances
resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

