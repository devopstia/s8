# Specify the provider
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-postgres-sg"
  description = "Security group for PostgreSQL RDS instance"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow all inbound traffic (not recommended for production)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "rds-postgres-sg"
    environment = "dev"
  }
}


resource "aws_db_instance" "education" {
  identifier        = "education"
  instance_class    = "db.t3.micro"
  allocated_storage = 10
  engine            = "postgres"
  engine_version    = "16.3"
  db_name           = "del"
  username          = "edu"
  password          = "SecurePass123!"
  #   db_subnet_group_name   = aws_db_subnet_group.education.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  skip_final_snapshot    = true

  tags = {
    Name        = "education"
    environment = "dev"
    created_by  = "Terraform"
  }
}

resource "aws_db_parameter_group" "education" {
  name   = "education"
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}
