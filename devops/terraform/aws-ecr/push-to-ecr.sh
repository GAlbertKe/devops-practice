#!/bin/bash

# Script to build, tag, and push Docker image to ECR
# Usage: ./push-to-ecr.sh [image-name] [tag]

set -e

# Configuration
IMAGE_NAME=${1:-"my-app"}
IMAGE_TAG=${2:-"latest"}

# Check if Terraform has been applied
if [ ! -f "terraform.tfstate" ]; then
  echo "Error: terraform.tfstate not found. Please run 'terraform apply' first."
  exit 1
fi

# Get repository URL from Terraform output
echo "Getting ECR repository URL from Terraform..."
REPO_URL=$(terraform output -raw repository_url 2>/dev/null)
AWS_REGION=$(terraform output -raw aws_region 2>/dev/null || echo "us-east-1")

if [ -z "$REPO_URL" ]; then
  echo "Error: Could not get repository URL from Terraform outputs."
  echo "Please ensure Terraform has been successfully applied."
  exit 1
fi

echo "Repository URL: $REPO_URL"
echo "AWS Region: $AWS_REGION"

# Authenticate Docker with ECR
echo ""
echo "Authenticating Docker with ECR..."
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$REPO_URL"

if [ $? -ne 0 ]; then
  echo "Error: Failed to authenticate with ECR."
  echo "Please ensure your AWS credentials are configured correctly."
  exit 1
fi

# Check if local image exists
if ! docker image inspect "$IMAGE_NAME:$IMAGE_TAG" >/dev/null 2>&1; then
  echo ""
  echo "Warning: Local image '$IMAGE_NAME:$IMAGE_TAG' not found."
  echo "Would you like to build it? (y/n)"
  read -r response

  if [[ "$response" =~ ^[Yy]$ ]]; then
    if [ ! -f "Dockerfile" ]; then
      echo "Error: Dockerfile not found in current directory."
      exit 1
    fi

    echo "Building Docker image..."
    docker build -t "$IMAGE_NAME:$IMAGE_TAG" .
  else
    echo "Exiting..."
    exit 1
  fi
fi

# Tag the image for ECR
echo ""
echo "Tagging image for ECR..."
docker tag "$IMAGE_NAME:$IMAGE_TAG" "$REPO_URL:$IMAGE_TAG"

# Also tag with git commit SHA if in a git repository
if git rev-parse --git-dir > /dev/null 2>&1; then
  GIT_SHA=$(git rev-parse --short HEAD)
  echo "Also tagging with git SHA: $GIT_SHA"
  docker tag "$IMAGE_NAME:$IMAGE_TAG" "$REPO_URL:$GIT_SHA"
  ADDITIONAL_TAG="$GIT_SHA"
fi

# Push to ECR
echo ""
echo "Pushing image to ECR..."
docker push "$REPO_URL:$IMAGE_TAG"

if [ -n "$ADDITIONAL_TAG" ]; then
  echo "Pushing additional tag: $ADDITIONAL_TAG"
  docker push "$REPO_URL:$ADDITIONAL_TAG"
fi

# Display pushed images
echo ""
echo "Successfully pushed images to ECR!"
echo "Repository: $REPO_URL"
echo "Tags:"
echo "  - $IMAGE_TAG"
[ -n "$ADDITIONAL_TAG" ] && echo "  - $ADDITIONAL_TAG"

echo ""
echo "To pull this image on another machine:"
echo "  aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REPO_URL"
echo "  docker pull $REPO_URL:$IMAGE_TAG"
