variable "ingress_ports" {
  description = "List of ingress ports to allow"
  type        = list(number)
}

variable "aws_region" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "tags" {
  type = map(string)
}
