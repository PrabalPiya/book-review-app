#!/bin/bash

set -e

IMAGE_TAG="latest"

echo "Building backend Docker image..."
docker build -t book-review-backend:$IMAGE_TAG ./backend

echo "Building frontend Docker image..."
docker build -t book-review-frontend:$IMAGE_TAG ./frontend

echo "Docker images built successfully."
echo "Backend image: book-review-backend:$IMAGE_TAG"
echo "Frontend image: book-review-frontend:$IMAGE_TAG"