terraform {
  backend "s3" {
    bucket         = "tasker-app-terraform-state"
    key            = "prod/terraform.tfstate" 
    region         = "us-east-1"
    dynamodb_table = "lock-state"
  }
}