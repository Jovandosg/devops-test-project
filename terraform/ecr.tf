resource "aws_ecr_repository" "ecr_devops" {
  name                 = "devops"
  image_tag_mutability = "MUTABLE"

}