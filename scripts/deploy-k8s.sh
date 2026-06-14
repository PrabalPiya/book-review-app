#!/bin/bash

set -e

AWS_ACCOUNT_ID="$AWS_ID"
AWS_REGION="ap-south-1"
IMAGE_TAG="latest"

FRONTEND_REPO="book-review-dev-frontend"
BACKEND_REPO="book-review-dev-backend"

DB_HOST="$AURORA_ENDPOINT"
DB_NAME="bookreviewdb"
DB_USER="admin"
DB_PASS="$DB_PASS"

ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

FRONTEND_IMAGE="$ECR_URL/$FRONTEND_REPO:$IMAGE_TAG"
BACKEND_IMAGE="$ECR_URL/$BACKEND_REPO:$IMAGE_TAG"

echo "Using backend image:"
echo "$BACKEND_IMAGE"

echo "Using frontend image:"
echo "$FRONTEND_IMAGE"

echo "Creating namespace..."
kubectl apply -f kubernetes/namespace.yaml

echo "Creating ConfigMap..."
kubectl create configmap book-review-config \
  --namespace book-review \
  --from-literal=NODE_ENV=production \
  --from-literal=PORT=5000 \
  --from-literal=DB_PORT=3306 \
  --from-literal=DB_DIALECT=mysql \
  --from-literal=DB_SSL=true \
  --from-literal=DB_HOST=$DB_HOST \
  --from-literal=DB_NAME=$DB_NAME \
  --from-literal=INTERNAL_BACKEND_URL=http://backend-service.book-review.svc.cluster.local:5000 \
  --dry-run=client \
  -o yaml | kubectl apply -f -

echo "Creating Secret..."
kubectl create secret generic book-review-db-secret \
  --namespace book-review \
  --from-literal=DB_USER=$DB_USER \
  --from-literal=DB_PASS=$DB_PASS \
  --dry-run=client \
  -o yaml | kubectl apply -f -

echo "Deploying backend..."
kubectl apply -f kubernetes/backend-deployment.yaml
kubectl apply -f kubernetes/backend-service.yaml

echo "Deploying frontend..."
kubectl apply -f kubernetes/frontend-deployment.yaml
kubectl apply -f kubernetes/frontend-service.yaml

echo "Updating backend image..."
kubectl set image deployment/backend backend=$BACKEND_IMAGE -n book-review

echo "Updating frontend image..."
kubectl set image deployment/frontend frontend=$FRONTEND_IMAGE -n book-review

echo "Applying autoscaling..."
kubectl apply -f kubernetes/hpa.yaml

echo "Waiting for backend to become ready..."
kubectl rollout status deployment/backend -n book-review

echo "Waiting for frontend to become ready..."
kubectl rollout status deployment/frontend -n book-review

echo "Deployment completed."
echo "Run this to check:"
echo "kubectl get all -n book-review"