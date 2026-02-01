# AWS Configuration
aws_region = "us-east-1"

# ECR Repository Configuration
repository_name  = "ecr-app"
environment      = "dev"
image_mutability = "MUTABLE"
scan_on_push     = true
encryption_type  = "AES256"

# Lifecycle Policy Configuration
enable_lifecycle_policy = true
image_count_to_keep     = 10
untagged_days_to_keep   = 7

# Repository Policy Configuration (for cross-account access)
enable_repository_policy = false
allowed_principal_arns   = []
# allowed_principal_arns = ["arn:aws:iam::123456789012:root"]

# Additional Tags
tags = {
  Project = "DevOpsProject"
  Owner   = "Albert"
}
