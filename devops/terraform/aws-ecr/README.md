# AWS ECR Terraform Demo

This Terraform configuration creates an AWS Elastic Container Registry (ECR) repository with lifecycle policies and optional cross-account access.

## Prerequisites

1. **AWS CLI** installed and configured
2. **Terraform** (>= 1.0) installed
3. **Docker** installed (for pushing images)
4. **AWS credentials** configured with appropriate permissions

## AWS Authentication

### Option 1: AWS CLI Configuration (Recommended)

```bash
# Configure AWS credentials
aws configure

# You'll be prompted for:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region name
# - Default output format

# Verify authentication
aws sts get-caller-identity
```

### Option 2: Environment Variables

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Option 3: AWS Profiles

```bash
# Configure a named profile
aws configure --profile myproject

# Use the profile with Terraform
export AWS_PROFILE=myproject
```

### Required AWS Permissions

Your IAM user/role needs the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:CreateRepository",
        "ecr:DeleteRepository",
        "ecr:DescribeRepositories",
        "ecr:PutLifecyclePolicy",
        "ecr:GetLifecyclePolicy",
        "ecr:DeleteLifecyclePolicy",
        "ecr:SetRepositoryPolicy",
        "ecr:GetRepositoryPolicy",
        "ecr:DeleteRepositoryPolicy",
        "ecr:TagResource",
        "ecr:UntagResource"
      ],
      "Resource": "*"
    }
  ]
}
```

## Configuration

1. **Copy the example variables file:**

```bash
cp terraform.tfvars.example terraform.tfvars
```

2. **Edit `terraform.tfvars` with your values:**

```hcl
aws_region      = "us-east-1"
repository_name = "my-app"
environment     = "dev"
```

## Usage

### 1. Initialize Terraform

```bash
terraform init
```

This will:
- Download the AWS provider plugin
- Initialize the backend
- Prepare the working directory

### 2. Validate Configuration

```bash
terraform validate
```

### 3. Plan the Changes

```bash
terraform plan
```

Review the execution plan to see what resources will be created.

### 4. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm.

### 5. View Outputs

```bash
terraform output

# View specific output
terraform output repository_url
terraform output docker_login_command
```

## Pushing Docker Images to ECR

### Step 1: Authenticate Docker with ECR

```bash
# Get the login command from Terraform output
terraform output docker_login_command

# Or run directly (replace REGION and ACCOUNT_ID)
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
```

### Step 2: Build Your Docker Image (if not already built)

```bash
# Example: Build a simple Node.js app
docker build -t my-app:latest .
```

### Step 3: Tag Your Image

```bash
# Get the repository URL from Terraform
REPO_URL=$(terraform output -raw repository_url)

# Tag your local image
docker tag my-app:latest $REPO_URL:latest

# Or tag with a specific version
docker tag my-app:latest $REPO_URL:v1.0.0
```

### Step 4: Push to ECR

```bash
# Push the latest tag
docker push $REPO_URL:latest

# Push a specific version
docker push $REPO_URL:v1.0.0
```

### Complete Example Script

```bash
#!/bin/bash

# Get repository URL from Terraform
REPO_URL=$(terraform output -raw repository_url)
AWS_REGION=$(terraform output -raw aws_region 2>/dev/null || echo "us-east-1")

# Authenticate Docker with ECR
echo "Authenticating Docker with ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REPO_URL

# Build the Docker image
echo "Building Docker image..."
docker build -t my-app:latest .

# Tag the image
echo "Tagging image..."
docker tag my-app:latest $REPO_URL:latest
docker tag my-app:latest $REPO_URL:$(git rev-parse --short HEAD)

# Push to ECR
echo "Pushing to ECR..."
docker push $REPO_URL:latest
docker push $REPO_URL:$(git rev-parse --short HEAD)

echo "Successfully pushed to ECR: $REPO_URL"
```

Save this as `push-to-ecr.sh` and make it executable:

```bash
chmod +x push-to-ecr.sh
./push-to-ecr.sh
```

## Pulling Images from ECR

```bash
# Authenticate (if not already done)
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <REPO_URL>

# Pull the image
docker pull $REPO_URL:latest

# Run the container
docker run -d -p 8080:8080 $REPO_URL:latest
```

## Verifying the ECR Repository

### Using AWS CLI

```bash
# List ECR repositories
aws ecr describe-repositories

# List images in the repository
aws ecr list-images --repository-name my-app

# Describe images with details
aws ecr describe-images --repository-name my-app
```

### Using AWS Console

1. Go to AWS Console
2. Navigate to **ECR** service
3. Select your region
4. Click on your repository name
5. View images and tags

## Lifecycle Policy

The configuration includes an automatic lifecycle policy that:

- Keeps the last **10 tagged images** (configurable via `image_count_to_keep`)
- Removes **untagged images** older than **7 days** (configurable via `untagged_days_to_keep`)

This helps manage storage costs by automatically cleaning up old images.

## Cleanup

To destroy all resources created by Terraform:

```bash
# Preview what will be destroyed
terraform plan -destroy

# Destroy the resources
terraform destroy
```

**Note:** Ensure the ECR repository is empty before destroying, or use the AWS CLI to force delete:

```bash
# Delete all images first
aws ecr batch-delete-image \
  --repository-name ecr-app \
  --image-ids "$(aws ecr list-images --repository-name ecr-app --query 'imageIds[*]' --output json)" || true

# Then run terraform destroy
terraform destroy
```

## Variables Reference

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `aws_region` | AWS region | `us-east-1` | No |
| `repository_name` | ECR repository name | - | Yes |
| `environment` | Environment name | `dev` | No |
| `image_mutability` | Tag mutability (MUTABLE/IMMUTABLE) | `MUTABLE` | No |
| `scan_on_push` | Scan images on push | `true` | No |
| `encryption_type` | Encryption type (AES256/KMS) | `AES256` | No |
| `enable_lifecycle_policy` | Enable lifecycle policy | `true` | No |
| `image_count_to_keep` | Number of images to retain | `10` | No |
| `untagged_days_to_keep` | Days to keep untagged images | `7` | No |
| `enable_repository_policy` | Enable cross-account access | `false` | No |
| `allowed_principal_arns` | ARNs allowed to pull images | `[]` | No |
| `tags` | Additional tags | `{}` | No |

## Outputs Reference

| Output | Description |
|--------|-------------|
| `repository_url` | Full URL of the ECR repository |
| `repository_arn` | ARN of the repository |
| `repository_name` | Name of the repository |
| `registry_id` | AWS account ID (registry ID) |
| `docker_login_command` | Command to authenticate Docker |
| `docker_push_commands` | Commands to tag and push images |

## Troubleshooting

### Authentication Issues

```bash
# Check AWS credentials
aws sts get-caller-identity

# Check Docker login
docker info | grep -A5 "Registry"
```

### Permission Denied

Ensure your AWS credentials have the required ECR permissions listed above.

### Repository Already Exists

If the repository already exists, you can import it:

```bash
terraform import aws_ecr_repository.app_repository my-app
```

### Docker Push Fails

```bash
# Re-authenticate
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <REPO_URL>

# Check repository exists
aws ecr describe-repositories --repository-names my-app
```

## Best Practices

1. **Use image tags**: Always tag images with versions (e.g., `v1.0.0`, `sha-abc123`)
2. **Enable scanning**: Keep `scan_on_push = true` to detect vulnerabilities
3. **Lifecycle policies**: Use lifecycle policies to manage storage costs
4. **Immutable tags**: For production, consider `image_mutability = "IMMUTABLE"`
5. **Encryption**: Use KMS encryption for sensitive workloads
6. **Cross-region replication**: Consider replication for disaster recovery
7. **IAM policies**: Use least-privilege IAM policies for ECR access

## Example Dockerfile

Here's a simple example Dockerfile to test with:

```dockerfile
FROM node:18-alpine

WORKDIR /app

# Create a simple app
RUN echo 'console.log("Hello from ECR!");' > index.js

CMD ["node", "index.js"]
```

Build and push:

```bash
docker build -t my-app:latest .
REPO_URL=$(terraform output -raw repository_url)
docker tag my-app:latest $REPO_URL:latest
docker push $REPO_URL:latest
```

## Additional Resources

- [AWS ECR Documentation](https://docs.aws.amazon.com/ecr/)
- [Terraform AWS Provider - ECR](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository)
- [Docker Documentation](https://docs.docker.com/)
