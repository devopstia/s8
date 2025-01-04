resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Allow HTTP traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
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
}

# EC2 Instances for Blue, Green, and Yellow pages
resource "aws_instance" "color_instances" {
  count           = 3
  ami             = "ami-01816d07b1128cd2d" # Amazon Linux 2 (replace with your region's AMI)
  instance_type   = "t2.micro"
  subnet_id       = element(var.private-subnets, count.index % length(var.private-subnets))
  security_groups = [aws_security_group.instance_sg.id]
  key_name        = "terraform-aws"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              yum install -y net-tools
              PRIVATE_IP=`ifconfig | grep 'inet ' | awk '{print $2}' | head -n 1`

              INSTANCE_INDEX=${count.index}
              if [ "$INSTANCE_INDEX" -eq 0 ]; then
                COLOR="blue"
                GRADIENT="to right, #0000FF, #00FFFF"
              elif [ "$INSTANCE_INDEX" -eq 1 ]; then
                COLOR="green"
                GRADIENT="to right, #00FF00, #008000"
              else
                COLOR="yellow"
                GRADIENT="to right, #FFFF00, #FFD700"
              fi

              echo "<html>
                      <head>
                        <style>
                          body {
                            background: linear-gradient($${GRADIENT});
                            color: white;
                            font-family: Arial, sans-serif;
                            text-align: center;
                            height: 100vh;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                          }
                        </style>
                      </head>
                      <body>
                        <h1>Hello from the $${COLOR} instance at $PRIVATE_IP</h1>
                      </body>
                    </html>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "color-instance-${count.index + 1}"
  }
}

# Attaching EC2 Instances to respective Target Groups
resource "aws_lb_target_group_attachment" "blue_attachment" {
  target_group_arn = aws_lb_target_group.blue.arn
  target_id        = aws_instance.color_instances[0].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "green_attachment" {
  target_group_arn = aws_lb_target_group.green.arn
  target_id        = aws_instance.color_instances[1].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "yellow_attachment" {
  target_group_arn = aws_lb_target_group.yellow.arn
  target_id        = aws_instance.color_instances[2].id
  port             = 80
}

resource "aws_route53_record" "blue_cname" {
  zone_id = "Z07283882P48FEHTX4ECS"
  name    = "blue.devopseasylearnings.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.main.dns_name]
}

resource "aws_route53_record" "green_cname" {
  zone_id = "Z07283882P48FEHTX4ECS"
  name    = "green.devopseasylearnings.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.main.dns_name]
}

resource "aws_route53_record" "yellow_cname" {
  zone_id = "Z07283882P48FEHTX4ECS"
  name    = "yellow.devopseasylearnings.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.main.dns_name]
}