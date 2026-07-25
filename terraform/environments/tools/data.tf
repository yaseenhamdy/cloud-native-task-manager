data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "terraform_remote_state" "prod" {
  backend = "s3"
  config = {
    bucket         = "tasker-app-terraform-state"
    key            = "prod/terraform.tfstate" 
    region         = "us-east-1"
  }
}

data "terraform_remote_state" "devtest" {
  backend = "s3"
  config = {
    bucket         = "tasker-app-terraform-state"
    key            = "dev-test/terraform.tfstate"
    region         = "us-east-1"
  }
}