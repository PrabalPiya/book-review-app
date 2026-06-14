#!/bin/bash

set -e

AWS_ACCOUNT_ID="your-aws-account-id"
AWS_REGION="ap-south-1"
IMAGE_TAG="latest"

FRONTEND_REPO="book-review-dev-frontend"
BACKEND_REPO="book-review-dev-backend"

ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

echo "Logging in to AWS ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL

echo "Tagging frontend image..."
docker tag book-review-frontend:$IMAGE_TAG $ECR_URL/$FRONTEND_REPO:$IMAGE_TAG

echo "Tagging backend image..."
docker tag book-review-backend:$IMAGE_TAG $ECR_URL/$BACKEND_REPO:$IMAGE_TAG

echo "Pushing frontend image..."
docker push $ECR_URL/$FRONTEND_REPO:$IMAGE_TAG

echo "Pushing backend image..."
docker push $ECR_URL/$BACKEND_REPO:$IMAGE_TAG

echo "Images pushed successfully."