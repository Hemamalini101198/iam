# backend-partial.tf
 
provider "aws" {
  region = "your-region"
}
 
terraform {
  backend "s3" {
    bucket         = "tf-statefiles-bucket"
    encrypt        = true
  }
}
