
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.7"  # Use latest stable version
    }
  }
}

# Primary AWS Provider (eu-west-2)
provider "aws" {
  region     = "eu-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# AWS Provider for Replica Region (us-east-1)
provider "aws" {
  alias      = "us-east-1"
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# AWS Provider for Additional Region (us-east-2)
provider "aws" {
  alias      = "us-east-2"
  region     = "us-east-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
