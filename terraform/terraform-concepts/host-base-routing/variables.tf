variable "vpc_id" {
  default = "vpc-09b5295b81445c391" # Replace with your VPC ID
}

variable "public-subnets" {
  default = [
    "subnet-0e4ff5c0f31072e14",
    "subnet-0bfce654d77874bd9",
    "subnet-08d007967f4d56e21"
  ] # Replace with your subnet IDs
}

variable "private-subnets" {
  default = [
    "subnet-00a1adcfb112d531b",
    "subnet-0eb52dd53a295dae0",
    "subnet-0bcaf06d55686a47a"
  ] # Replace with your subnet IDs
}
