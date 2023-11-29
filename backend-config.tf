terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.50.0"
    }
  }

# backend-config.tf

variable "user_name" {}

locals {
  key_prefix = "iam/${var.user_name}"
}

backend "s3" {
  bucket = "tf-statefiles-bucket"
  key    = local.key_prefix != "" ? "${local.key_prefix}/terraform.tfstate" : "terraform.tfstate"
  region = "ap-south-1"
}
}
