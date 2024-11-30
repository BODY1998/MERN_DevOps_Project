module "networking" {
  source              = "./modules/networking"
  vpc_cidr            = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
}

module "eks" {
  source          = "./modules/eks"
  vpc_id          = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  public_subnets  = module.networking.public_subnets
  eks_sg          = module.networking.eks_security_group_id
  ssh_key_name    = var.ssh_key_name
  cluster_name    = var.cluster_name
  desired_nodes   = var.desired_nodes
  min_nodes       = var.min_nodes
  max_nodes       = var.max_nodes
  instance_types  = var.instance_types
}

module "rds" {
  source = "./modules/rds"
  db_name              = var.db_name
  vpc_id               = module.networking.vpc_id
  db_username          = var.db_username
  db_password          = var.db_password
  private_subnets      = module.networking.private_subnets 
}

module "jenkins" {
  source = "./modules/jenkins"

  ami_id      = var.ami_id
  instance_type = var.instance_type
  vpc_id      = module.networking.vpc_id
  subnet_id   = module.networking.private_subnets[0]
  key_pair    = var.key_pair
}

module "backup" {
  source = "./modules/backup"

  backup_vault_name    = "jenkins-backup-vault"
  backup_plan_name     = "jenkins-backup-plan"
  backup_rule_name     = "daily-backup-rule"
  backup_schedule      = "cron(0 5 * * ? *)"  # Daily at 5 AM UTC
  retention_days       = 30
  backup_selection_name = "jenkins-backup-selection"
  backup_resources     = [module.jenkins.jenkins_instance_arn]  # ARN of Jenkins EC2 instance
}

module "alb_logging" {
  source = "./modules/alb-logging"

  alb_access_log_bucket_name = "my-alb-access-logs"
  aws_account_id             = var.aws_account_id
  alb_log_prefix             = "logs/"
  alb_name                   = module.eks.alb_name   # Assume ALB is created in EKS module
  alb_security_groups        = module.eks.alb_security_groups
  alb_subnets                = module.networking.private_subnets
  environment                = var.environment
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = "my-app-repo"
  environment     = var.environment
}