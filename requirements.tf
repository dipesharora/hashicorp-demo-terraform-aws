#########################################################
## Terraform Version Used
#########################################################
terraform {
  required_version = "=1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "=0.44.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "hcp" {}