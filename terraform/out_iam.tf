# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "ecr-ec2-role"
resource "aws_iam_instance_profile" "ecr-ec2-role" {
  name        = "ecr-ec2-role"
  name_prefix = null
  path        = "/"
  role        = aws_iam_role.ecr-ec2-role.name
  tags        = {}
  tags_all    = {}
}

# __generated__ by Terraform from "ecr-ec2-role"
resource "aws_iam_role" "ecr-ec2-role" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  description           = "Allows EC2 instances to call AWS services on your behalf."
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "ecr-ec2-role"
  name_prefix           = null
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}
}

# Política para permitir acesso ao ECR
resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.ecr-ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Política adicional para permitir login no ECR
resource "aws_iam_role_policy" "ecr_token" {
  name = "ecr-token-policy"
  role = aws_iam_role.ecr-ec2-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}
