terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.1"
    }
  }
  # see root README and the TF in bootstrap/ on how to generate an s3 backend.
  backend "s3" {
    bucket         = "dtns-devtest-tf-state-us-east-1"
    key            = "state/template-tf/terraform.tfstate"
    dynamodb_table = "tf-state-dtnsdevtest-us-east-1"
    region         = "us-east-1"
    encrypt        = "true"
  }
}

resource "random_string" "bucket_name" {
  length  = 16
  special = false
  upper   = false
  number  = false
}

resource "aws_s3_bucket" "example" {
  bucket = "myapp-${random_string.bucket_name.result}"
  acl    = "private"  # Set the ACL according to your requirements

  tags = {
    Name        = "My application"
    Environment = "Dev"
  }
}