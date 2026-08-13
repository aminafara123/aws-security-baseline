terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Local state is fine for a single-owner portfolio project. For anything
  # shared or long-lived, switch to a remote backend with state locking:
  #
  # backend "s3" {
  #   bucket         = "my-terraform-state-bucket"
  #   key            = "aws-security-baseline/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}
