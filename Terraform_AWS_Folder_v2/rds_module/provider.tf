

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"  # Specify the version if necessary
    }
  }
}

# Provider for the primary region (eu-west-2)
provider "aws" {
  region = "eu-west-2"
}

# Provider for the replica region (us-east-1)
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# Provider for the additional region (us-east-2)
provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

