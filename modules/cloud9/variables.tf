variable "instance_name" {
  type        = string
  description = "The name of the Cloud9 environment."
}

variable "instance_type" {
  default     = "t2.micro"
  description = "The instance type for the Cloud9 environment."
}

