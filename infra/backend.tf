terraform {
  backend "s3" {
    bucket         = "test-push-notification"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "test-push-notification-bd"
    encrypt        = true
  }
}