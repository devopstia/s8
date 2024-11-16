resource "aws_instance" "ec2" {
  ami           = data.aws_ami.jenkins_master_ami.id
  instance_type = "t2.micro"

  # Add a key pair for SSH access
  key_name = "terraform-aws"

  # Security Group to allow SSH and HTTP access
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Associate instance with specific subnet
  subnet_id = data.aws_subnet.subnet_01.id

  # Specify the root block device to set the volume size to 30 GB and type to gp3
  root_block_device {
    volume_size = 30    # Size in GB
    volume_type = "gp3" # Set volume type to gp3
  }

  # tags = {
  #   Name           = "${var.tags["environment"]}-${var.tags["project"]}-${var.resource_type}"
  #   owner          = var.tags["owner"]
  #   environment    = var.tags["environment"]
  #   project        = var.tags["project"]
  #   create_by      = var.tags["create_by"]
  #   cloud_provider = var.tags["cloud_provider"]
  # }

  #   variable "tags" {
  #   type = map(string)
  #   default = {
  #     "owner"          = "EK TECH SOFTWARE SOLUTION"
  #     "environment"    = "prod"
  #     "project"        = "alpha"
  #     "create_by"      = "Terraform"
  #     "cloud_provider" = "aws"
  #   }
  # }


  tags = merge(var.tags, {
    Name = format("%s-%s-${var.resource_type}", var.tags["environment"], var.tags["project"])
  })

  # tags = merge(var.tags, {
  #   Name = "dev-del-bastion-host"
  # })
}