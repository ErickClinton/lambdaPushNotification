terraform {
  required_version = "1.9.8"
}

provider "aws" {
  region  = var.aws_region
  default_tags {
    tags = {
      Project   = "Lambda Layers with Terraform"
      CreatedAt = formatdate("YYYY-MM-DD", timestamp())
      ManagedBy = "Terraform"
      Owner     = "Erick Clinton"
    }
  }
}