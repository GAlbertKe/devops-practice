variable "aws_region" {
  description = "AWS region where ECR repository will be created"
  type        = string
  default     = "us-east-1"
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "ecr-app"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
  default     = "dev"
}

variable "image_mutability" {
  description = "The tag mutability setting for the repository (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_mutability)
    error_message = "Image mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "The encryption type to use for the repository (AES256 or KMS)"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "Encryption type must be either AES256 or KMS."
  }
}

variable "enable_lifecycle_policy" {
  description = "Enable lifecycle policy to manage image retention"
  type        = bool
  default     = true
}

variable "image_count_to_keep" {
  description = "Number of tagged images to retain"
  type        = number
  default     = 10
}

variable "untagged_days_to_keep" {
  description = "Number of days to keep untagged images"
  type        = number
  default     = 7
}

variable "enable_repository_policy" {
  description = "Enable repository policy for cross-account access"
  type        = bool
  default     = false
}

variable "allowed_principal_arns" {
  description = "List of AWS principal ARNs allowed to pull images"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags for the ECR repository"
  type        = map(string)
  default     = {}
}
