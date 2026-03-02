terraform {
  backend "s3" {
    bucket = "terraform-ci-cd-s3-v5"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}