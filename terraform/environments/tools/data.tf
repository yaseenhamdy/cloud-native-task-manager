data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "terraform_remote_state" "prod" {
  count   = var.register_prod ? 1 : 0
  backend = "s3"
  config = {
    bucket = "tasker-app-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "devtest" {
  count   = var.register_devtest ? 1 : 0
  backend = "s3"
  config = {
    bucket = "tasker-app-terraform-state"
    key    = "dev-test/terraform.tfstate"
    region = "us-east-1"
  }
}