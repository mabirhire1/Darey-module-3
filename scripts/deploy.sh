#!/bin/bash

set -e

# Configuration
AWS_REGION="us-east-1"
PROJECT_NAME="webapp"
ENVIRONMENT="dev"
IMAGE_TAG="latest"

echo "Starting deployment process..."

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Plan Terraform changes
echo "Planning Terraform changes..."
terraform plan

# Apply Terraform configuration
echo "Applying Terraform configuration..."
terraform apply -auto-approve

# Get ECR repository URL
ECR_REPO_URL=$(terraform output -raw ecr_repository_url)
echo "ECR Repository URL: $ECR_REPO_URL"

# Login to ECR
echo "Logging into ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO_URL

# Build and tag Docker image
echo "Building Docker image..."
cd app
docker build -t $PROJECT_NAME:$IMAGE_TAG .
docker tag $PROJECT_NAME:$IMAGE_TAG $ECR_REPO_URL:$IMAGE_TAG

# Push image to ECR
echo "Pushing image to ECR..."
docker push $ECR_REPO_URL:$IMAGE_TAG

# Force ECS service update
echo "Updating ECS service..."
aws ecs update-service \
  --cluster ${PROJECT_NAME}-${ENVIRONMENT}-cluster \
  --service ${PROJECT_NAME}-${ENVIRONMENT}-service \
  --force-new-deployment \
  --region $AWS_REGION

echo "Deployment completed successfully!"

# Get application URL
cd ..
APP_URL=$(terraform output -raw application_url)
echo "Application URL: $APP_URL"
echo "Please wait a few minutes for the service to be fully available."
