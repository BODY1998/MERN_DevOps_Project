output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "node_group_arn" {
  value = aws_eks_node_group.node_group.arn
}

# Output the EKS Cluster Endpoint
output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = aws_eks_cluster.eks.endpoint
}

# Output the EKS Cluster ARN
output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = aws_eks_cluster.eks.arn
}

# Output the Security Group for EKS
output "eks_security_group" {
  description = "The security group ID for the EKS worker nodes"
  value       = aws_security_group.eks_sg.id
}

# Output the Worker Node IAM Role
output "worker_node_role" {
  description = "The IAM role for the EKS worker nodes"
  value       = aws_iam_role.worker_role.arn
}

# Output the Auto Scaling Group Name
output "worker_asg_name" {
  description = "The name of the Auto Scaling Group for the worker nodes"
  value       = aws_autoscaling_group.worker_asg.name
}

# Output the Load Balancer DNS name
output "elb_dns_name" {
  description = "DNS name of the Elastic Load Balancer"
  value       = aws_lb.eks_alb.dns_name
}

# Output the EKS Target Group ARN (for Load Balancer attachment)
output "target_group_arn" {
  description = "ARN of the Target Group used by the Elastic Load Balancer"
  value       = aws_lb_target_group.eks_target_group.arn
}
