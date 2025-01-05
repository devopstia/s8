resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow HTTP traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [data.aws_security_group.alb_sg.id]
  }

  #   ingress {
  #     from_port   = 443
  #     to_port     = 443
  #     protocol    = "tcp"
  #     security_groups = [data.aws_security_group.alb_sg.id]
  #   }

  #   ingress {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     security_groups = [data.aws_security_group.alb_sg.id]
  #   }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch Template for Jenkins EC2 instances
resource "aws_launch_template" "jenkins_lt" {
  name          = "jenkins-launch-template"
  image_id      = "ami-0832a077d6dad7d7e"
  instance_type = "t2.medium"
  key_name      = "terraform-aws"

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = "20"
      volume_type = "gp3"
    }
  }

  network_interfaces {
    security_groups = [aws_security_group.jenkins_sg.id]
    subnet_id       = element(var.private-subnets, 0)
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "jenkins-master"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "jenkins_asg" {
  launch_template {
    id      = aws_launch_template.jenkins_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier       = var.private-subnets
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 5
  health_check_type         = "EC2"
  health_check_grace_period = 300

  target_group_arns = [data.aws_lb_target_group.jenkins_target_group.arn]

  tag {
    key                 = "Name"
    value               = "jenkins-master"
    propagate_at_launch = true
  }
}

# Attach the Auto Scaling Group to the Load Balancer Target Group
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.jenkins_asg.id
  lb_target_group_arn    = data.aws_lb_target_group.jenkins_target_group.arn
}

# Scaling policy for CPU utilization
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.jenkins_asg.id
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.jenkins_asg.id
}

# CNAME Record for jenkins.devopseasylearnings.com
resource "aws_route53_record" "jenkins_cname" {
  zone_id = "Z07283882P48FEHTX4ECS" # Replace with your actual hosted zone ID
  name    = "jenkins"
  type    = "CNAME"
  ttl     = 300
  records = [data.aws_lb.alb.dns_name] # ALB DNS name
}