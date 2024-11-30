# IAM role for EKS
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS cluster
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [var.eks_sg]
  }
}

# IAM role for worker nodes
resource "aws_iam_role" "worker_role" {
  name = "eks-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Node group for EKS
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_role_arn   = aws_iam_role.worker_role.arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = var.desired_nodes
    min_size     = var.min_nodes
    max_size     = var.max_nodes
  }

  instance_types = var.instance_types
}

#----------------------------------------------------------------

# Launch Template for worker nodes
resource "aws_launch_template" "worker_template" {
  name_prefix   = "${var.cluster_name}-worker"
  image_id      = var.worker_ami_id 
  instance_type = var.instance_types[0]   

  iam_instance_profile {
    name = aws_iam_role.worker_role.name
  }

  key_name = var.ssh_key_name   # Key pair for SSH access

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.eks_sg]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-worker"
    }
  }
}

# Auto Scaling Group for worker nodes
resource "aws_autoscaling_group" "worker_asg" {
  launch_template {
    id      = aws_launch_template.worker_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.private_subnets  # Attach instances to private subnets
  min_size            = var.min_nodes
  max_size            = var.max_nodes
  desired_capacity    = var.desired_nodes

  target_group_arns = [aws_lb_target_group.eks_target_group.arn]  # Attach instances to the ELB target group

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-worker"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
}
#----------------------------------------------------------------



resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_policy" {
  role       = aws_iam_role.worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Instance profile for worker nodes
resource "aws_iam_instance_profile" "worker_node_profile" {
  name = "eks-worker-node-profile"
  role = aws_iam_role.worker_role.name
}
#----------------------------------------------------------------

# EKS cluster and Node Group association through aws-auth configmap
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = jsonencode([{
      rolearn  = aws_iam_role.worker_role.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }])
  }
}

#----------------------------------------------------------------

# Application Load Balancer (ALB)
resource "aws_lb" "eks_alb" {
  name               = "${var.cluster_name}-alb"
  load_balancer_type = "application"
  security_groups    = [var.eks_sg]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "${var.cluster_name}-alb"
  }
}

# Target group for worker nodes
resource "aws_lb_target_group" "eks_target_group" {
  name     = "${var.cluster_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/healthz"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

# Listener for ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.eks_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_target_group.arn
  }
}

