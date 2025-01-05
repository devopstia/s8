provider "aws" {
  region = "us-east-1"
}

## Terraform block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

variable "vpc_id" {
  default = "vpc-068852590ea4b093b"
}

variable "subnets" {
  default = ["subnet-096d45c28d9fb4c14", "subnet-05f285a35173783b0", "subnet-0fe3255479ad7c3a4"]
}

# Security Group for ALB and EC2 Instances
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP traffic for ALB"
  vpc_id      = var.vpc_id

  # Ingress rule for HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule for HTTPS (port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # # Ingress rule for HTTPS (port 443)
  # ingress {
  #   from_port   = 8080
  #   to_port     = 8080
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # # Ingress rule for HTTPS (port 443)
  # ingress {
  #   from_port   = 9000
  #   to_port     = 9000
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # Egress rule for all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "alb-sg"
    Environment = "development"
  }
}

# Application Load Balancer
resource "aws_lb" "main" {
  depends_on = [aws_security_group.alb_sg]
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnets

  enable_deletion_protection = false
}

# Create Target Groups
resource "aws_lb_target_group" "jenkins" {
  name     = "jenkins-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"   

  health_check {
    path                = "/login"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "jenkins-tg"
    Environment = "development"
  }
}

resource "aws_lb_target_group" "apache" {
  name     = "apache-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"   

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "apache-tg"
    Environment = "development"
  }
}

resource "aws_lb_target_group" "sonarqube" {
  name     = "sonarqube-tg"
  port     = 9000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"  

  health_check {
    path                = "/api/system/status"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "sonarqube-tg"
    Environment = "development"
  }
}

# HTTP Listener for Redirecting to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      host        = "#{host}"           
      path        = "/"
      port        = "443"              
      protocol    = "HTTPS"             
      query       = "#{query}"          
      status_code = "HTTP_301"       
    }
  }
}

# HTTPS Listener for Application Traffic
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = "arn:aws:acm:us-east-1:788210522308:certificate/be720f55-e320-4ad7-8f0c-5d1a3168e4db"

  # Default action (should only be applied if no rules match)
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.apache.arn
  }
}

# Define Routing Rules for the HTTPS Listener
resource "aws_lb_listener_rule" "jenkins" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  condition {
    host_header {
      values = ["jenkins.devopseasylearnings.com"]
    }
  }

  action {
    type              = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  }
}

resource "aws_lb_listener_rule" "apache" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 101

  condition {
    host_header {
      values = ["apache.devopseasylearnings.com"]
    }
  }
  
  action {
    type              = "forward"
    target_group_arn = aws_lb_target_group.apache.arn
  }
}

resource "aws_lb_listener_rule" "sonarqube" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 102

  condition {
    host_header {
      values = ["sonarqube.devopseasylearnings.com"]
    }
  }

  action {
    type              = "forward"
    target_group_arn = aws_lb_target_group.sonarqube.arn
  }
}