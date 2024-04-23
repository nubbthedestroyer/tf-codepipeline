module "bootstrap_tf" {
  source  = "trussworks/bootstrap/aws"
  version = "5.2.0"

  account_alias        = var.account_alias
  dynamodb_table_name  = var.dynamodb_table_name
  region               = var.region
  manage_account_alias = false
}

variable "region" {
  description = "AWS Region to use when bootstrapping"
  type    = string
}

variable "account_alias" {
  description = "AWS Account Alias where we will be bootstrapping"
  type    = string
}

variable "dynamodb_table_name" {
  description = "Reasonable name for the dynamodb table."
  type    = string
}

variable "s3_key" {
  description = "Path under the generated bucket that state will be stored."
  type = string
}

output "state_bucket" {
  description = "The state_bucket name"
  value       = module.bootstrap_tf.state_bucket
}

output "logging_bucket" {
  description = "The logging_bucket name"
  value       = module.bootstrap_tf.logging_bucket
}

output "dynamodb_table" {
  description = "The name of the dynamo db table"
  value       = module.bootstrap_tf.dynamodb_table
}

output "s3_backend_config" {
  value       = <<EOT

backend "s3" {
    bucket         = "${module.bootstrap_tf.state_bucket}"
    key            = "account-state/terraform.tfstate"
    dynamodb_table = "${module.bootstrap_tf.dynamodb_table}"
    region         = "${var.region}"
    encrypt        = "true"
}

EOT
  description = "This output can be used as the backend configuration for another Terraform workspace."
}
