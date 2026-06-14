#!/bin/bash

set -e

echo "Deleting Kubernetes app..."
kubectl delete namespace book-review --ignore-not-found=true

echo "Now destroying Terraform infrastructure..."
cd terraform/environments/dev
terraform destroy