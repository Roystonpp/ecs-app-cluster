# Specifying the region
provider "aws" {
  region = "eu-west-1"
}

# Creating the ECR
resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = false
  }
}