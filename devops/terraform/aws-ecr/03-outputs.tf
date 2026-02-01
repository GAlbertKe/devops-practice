output "repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app_repository.repository_url
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.app_repository.arn
}

output "repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.app_repository.name
}

output "registry_id" {
  description = "Registry ID where the repository was created"
  value       = aws_ecr_repository.app_repository.registry_id
}

output "docker_login_command" {
  description = "Command to authenticate Docker with ECR"
  value       = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.app_repository.repository_url}"
}

# output "docker_push_commands" {
#   description = "Commands to tag and push a Docker image to ECR"
#   value = {
#     tag  = "docker tag <local-image>:latest ${aws_ecr_repository.app_repository.repository_url}:latest"
#     push = "docker push ${aws_ecr_repository.app_repository.repository_url}:latest"
#   }
# }
