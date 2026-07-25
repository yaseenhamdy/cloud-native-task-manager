data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "terraform_remote_state" "tools" {
  backend = "s3"
  config = {
    bucket         = "tasker-app-terraform-state"
    key            = "tools/terraform.tfstate" 
    region         = "us-east-1"
  }
}