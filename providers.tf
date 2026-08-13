provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = var.project_name
      Owner     = "Al Amin Bashir Afara"
      ManagedBy = "Terraform"
    }
  }
}

# Identity and partition lookups so account IDs and partition names are never
# hardcoded anywhere in this configuration.
data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}
