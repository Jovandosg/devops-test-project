# state.tf
terraform {
  backend "s3" {
    bucket  = "project-devops-test"
    key     = "devops-project-test/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}
