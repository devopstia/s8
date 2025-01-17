plugin "aws" {
    enabled    = true
    deep_check = true
    version    = "0.37.0"
    source     = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "aws_instance_invalid_key_name" {
  enabled = true
}

rule "aws_instance_invalid_ami" {
  enabled = true
}