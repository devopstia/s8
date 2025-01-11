# Data source to get security group by tags
data "aws_security_group" "alb_sg" {
  filter {
    name   = "tag:Name"
    values = ["alb-sg"]
  }

  filter {
    name   = "tag:Environment"
    values = ["development"]
  }
}

# Data source to get ALB Target Group by name
data "aws_lb_target_group" "jenkins_target_group" {
  name = "jenkins-tg"
}

# Data source to get ALB by name
data "aws_lb" "alb" {
  name = "alb" # Replace with your ALB name
}