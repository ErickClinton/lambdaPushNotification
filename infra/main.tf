terraform {
  required_version = "1.9.8"
}

provider "aws" {
  region  = var.aws_region

}