resource "aws_ecr_repository" "this" {
  name                 = "${var.project_name}-ecr-repository"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}