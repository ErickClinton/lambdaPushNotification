locals {
  lambdas_path = "${path.module}/../hello-word"
  layers_path  = "${path.module}/../layers"

  common_tags = {
    Project   = "Lambda Layers with Terraform"
    CreatedAt = formatdate("YYYY-MM-DD", timestamp())
    ManagedBy = "Terraform"
    Owner     = "Erick Clinton"
  }
}