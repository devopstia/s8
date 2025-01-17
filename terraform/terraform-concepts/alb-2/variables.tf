variable "vpc_id" {
  type    = string
  default = "vpc-068852590ea4b093b" # Replace with your VPC ID
}

variable "public-subnets" {
  type = list(string)
  default = [
    "subnet-096d45c28d9fb4c14",
    "subnet-05f285a35173783b0",
    "subnet-0cf0e3c5a513134bd"
  ] # Replace with your subnet IDs
}

variable "private-subnets" {
  type = list(string)
  default = [
    "subnet-096d45c28d9fb4c14",
    "subnet-05f285a35173783b0",
    "subnet-0cf0e3c5a513134bd"
  ] # Replace with your subnet IDs
}
