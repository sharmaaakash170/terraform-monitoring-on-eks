terraform {
  backend "s3" {
    bucket         = "terraform-monitoring-on-eks-tfstate-bucket"
    key            = "envs/terraform-monitoring-on-eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-table"
    encrypt        = true
  }
}