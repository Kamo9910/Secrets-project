resource "aws_ecr_repository" "secret_app" {
    name = var.app-name
  }