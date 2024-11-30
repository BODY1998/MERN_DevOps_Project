# Jenkins Security Group
resource "aws_security_group" "jenkins_sg" {
  vpc_id = var.vpc_id

  # Allow HTTP access to Jenkins (port 8080)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access (port 22) for management
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins Security Group"
  }
}

# IAM Role for Jenkins EC2 Instance
resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to allow Jenkins access to AWS services
resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Instance Profile for the Jenkins EC2 instance
resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_role.name
}

# Jenkins EC2 Instance
resource "aws_instance" "jenkins" {
  ami                         = var.ami_id  # Example: Amazon Linux 2 AMI
  instance_type               = var.instance_type
  subnet_id                   = subnet_id  # Deploy in private or public subnet
  key_name                    = var.key_pair
  iam_instance_profile        = aws_iam_instance_profile.jenkins_instance_profile.name
  security_groups             = [aws_security_group.jenkins_sg.id]  # Attach Jenkins SG

  # Install Jenkins with user data script
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install java-openjdk11 -y
              sudo wget -O /etc/yum.repos.d/jenkins.repo \
                  https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              sudo yum install jenkins -y
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              EOF

  root_block_device {
    volume_size = 30  # Size of the EBS volume in GB
    volume_type = "gp2"
  }

  tags = {
    Name = "Jenkins EC2 Instance"
  }
}
