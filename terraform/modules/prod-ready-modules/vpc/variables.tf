variable "aws_region" {
  type        = string
  description = "The AWS region where the infrastructure will be deployed. Examples: us-west-2, eu-central-1. This variable ensures that resources are created in the specified AWS region."
}

variable "availability_zones" {
  type        = list(any)
  description = "A list of Availability Zones (AZs) within the selected region where resources (like subnets or EC2 instances) will be deployed. This allows for distributing resources across multiple AZs to improve availability and fault tolerance. Example: ['us-west-2a', 'us-west-2b', 'us-west-2c']."
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block for the Virtual Private Cloud (VPC). This defines the IP address range for the VPC. Example: 10.0.0.0/16 reserves IP addresses from 10.0.0.0 to 10.0.255.255 for the VPC."
}

variable "tags" {
  type        = map(string)
  description = "A map of key-value pairs representing common tags to apply to AWS resources (such as Name, Environment). Tags help in organizing and identifying resources, especially in large-scale environments."
}

variable "control_plane_name" {
  type        = string
  description = "The name of the Kubernetes cluster (or another cluster-type resource). It uniquely identifies the cluster in the environment, especially useful in cases like Amazon EKS."
}