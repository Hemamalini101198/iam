terraform {
  backend "s3" {
    key            = "iam/${terraform.workspace}/terraform.tfstate"
    region         = "your-region"
    encrypt        = true
  }
}
 
provider "aws" {
  region = "your-region"
}
