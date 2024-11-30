output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "eks_security_group_id" {
  description = "The security group ID for the EKS cluster"
  value       = aws_security_group.eks_sg.id
}
