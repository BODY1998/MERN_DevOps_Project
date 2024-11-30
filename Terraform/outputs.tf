output "vpc_id" {
  value = module.networking.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_node_group_arn" {
  value = module.eks.node_group_arn
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.networking.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.networking.private_subnets
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = module.eks.eks_cluster_endpoint
}

output "worker_node_role" {
  description = "The IAM role for the EKS worker nodes"
  value       = module.eks.worker_node_role
}

output "worker_asg_name" {
  description = "The name of the Auto Scaling Group for the worker nodes"
  value       = module.eks.worker_asg_name
}

output "elb_dns_name" {
  description = "The DNS name of the Elastic Load Balancer for the EKS cluster"
  value       = module.eks.elb_dns_name
}

output "target_group_arn" {
  description = "ARN of the Target Group used by the Elastic Load Balancer"
  value       = module.eks.target_group_arn
}

output "ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = module.ecr.ecr_repository_name
}

output "ecr_repository_uri" {
  description = "The URI of the ECR repository"
  value       = module.ecr.ecr_repository_uri
}
