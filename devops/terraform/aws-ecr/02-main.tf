terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create ECR Repository
resource "aws_ecr_repository" "app_repository" {
  name                 = var.repository_name
  image_tag_mutability = var.image_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
  }

  tags = merge(
    var.tags,
    {
      Name        = var.repository_name
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  )
}

# ECR Lifecycle Policy (Optional - helps manage image retention)
# resource "aws_ecr_lifecycle_policy" "app_repository_policy" {
#   count      = var.enable_lifecycle_policy ? 1 : 0
#   repository = aws_ecr_repository.app_repository.name
#
#   policy = jsonencode({
#     rules = [
#       {
#         rulePriority = 1
#         description  = "Keep last ${var.image_count_to_keep} images"
#         selection = {
#           tagStatus     = "tagged"
#           tagPrefixList = ["v"]
#           countType     = "imageCountMoreThan"
#           countNumber   = var.image_count_to_keep
#         }
#         action = {
#           type = "expire"
#         }
#       },
#       {
#         rulePriority = 2
#         description  = "Remove untagged images older than ${var.untagged_days_to_keep} days"
#         selection = {
#           tagStatus   = "untagged"
#           countType   = "sinceImagePushed"
#           countUnit   = "days"
#           countNumber = var.untagged_days_to_keep
#         }
#         action = {
#           type = "expire"
#         }
#       }
#     ]
#   })
# }

# ECR Repository Policy (Optional - for cross-account access)
# resource "aws_ecr_repository_policy" "app_repository_policy" {
#   count      = var.enable_repository_policy ? 1 : 0
#   repository = aws_ecr_repository.app_repository.name
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowPull"
#         Effect = "Allow"
#         Principal = {
#           AWS = var.allowed_principal_arns
#         }
#         Action = [
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage",
#           "ecr:BatchCheckLayerAvailability"
#         ]
#       }
#     ]
#   })
# }
