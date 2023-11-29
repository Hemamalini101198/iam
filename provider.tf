terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.50.0"
    }
  }
  backend "s3" {
    bucket = "tf-statefiles-bucket"
    key    = "iam/${terraform.workspace}/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}
