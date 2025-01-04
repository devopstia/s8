variable "aws_region" {
  type        = string
  description = "The AWS region where the infrastructure resources will be deployed. Example: us-east-1. This ensures that all AWS services and resources are provisioned in the specified region."
}

variable "domain_name" {
  type        = string
  description = "The fully qualified domain name (FQDN) for which the certificate will be issued or associated with. This is typically the primary domain for an application or website."
}

variable "subject_alternative_names" {
  type        = string
  description = "A list of additional domain names (Subject Alternative Names or SANs) for the SSL/TLS certificate. This allows the certificate to cover multiple domains or subdomains."
}

variable "tags" {
  type        = map(any)
  description = "A map of key-value pairs representing metadata tags to be applied to AWS resources. Tags help categorize, manage, and identify resources, particularly in large environments."
}
