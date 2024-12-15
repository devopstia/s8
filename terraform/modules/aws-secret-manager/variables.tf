variable "aws_region" {
  type = string
}

variable "secret_names" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}
