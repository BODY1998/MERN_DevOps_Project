# Output Jenkins EC2 public IP
output "jenkins_public_ip" {
  description = "The public IP of the Jenkins EC2 instance"
  value       = aws_instance.jenkins.public_ip
}

# Output Jenkins EC2 public DNS
output "jenkins_public_dns" {
  description = "The public DNS of the Jenkins EC2 instance"
  value       = aws_instance.jenkins.public_dns
}
