# Book Review App - DevOps Project

This is a beginner-friendly DevOps project for deploying a three-tier Book Review web application on AWS.

The project uses:

* Frontend: Next.js
* Backend: Node.js / Express
* Database: Amazon Aurora MySQL
* Containerization: Docker
* Kubernetes: AWS EKS
* Infrastructure as Code: Terraform
* Container Registry: AWS ECR

---

## Project Architecture

```text
User Browser
   |
   v
AWS Load Balancer
   |
   v
Frontend Pod on EKS
   |
   v
Backend Service inside Kubernetes
   |
   v
Backend Pod on EKS
   |
   v
Aurora MySQL Database in Private Subnet
```

---

## Folder Structure

```text
book-review-app/
├── frontend/
│   ├── Dockerfile
│   └── frontend source code
├── backend/
│   ├── Dockerfile
│   └── backend source code
├── terraform/
│   ├── environments/
│   │   └── dev/
│   └── modules/
├── kubernetes/
├── scripts/
└── README.md
```

---

## What Each Tool Does

| Tool            | Purpose                                              |
| --------------- | ---------------------------------------------------- |
| Docker          | Packages frontend and backend into container images  |
| AWS ECR         | Stores Docker images                                 |
| Terraform       | Creates AWS infrastructure                           |
| AWS EKS         | Runs the application using Kubernetes                |
| Aurora MySQL    | Stores application data                              |
| Kubernetes YAML | Deploys frontend and backend workloads               |
| Bash Scripts    | Simplifies build, push, deploy, and cleanup commands |

---

## Prerequisites

Install these tools before starting:

* Git
* Docker
* AWS CLI
* Terraform
* kubectl

Configure AWS:

```bash
aws configure
```

Check AWS login:

```bash
aws sts get-caller-identity
```

---

## Step 1: Clone the Repository

```bash
git clone https://github.com/PrabalPiya/book-review-app.git
cd book-review-app
```

---

## Step 2: Create AWS Infrastructure

Go to the Terraform dev folder:

```bash
cd terraform/environments/dev
```

Initialize Terraform:

```bash
terraform init
```

Format Terraform code:

```bash
terraform fmt -recursive
```

Validate Terraform code:

```bash
terraform validate
```

Preview the infrastructure:

```bash
terraform plan
```

Create the infrastructure:

```bash
terraform apply
```

Type:

```text
yes
```

Terraform creates:

* VPC
* Public subnets
* Private subnets
* EKS cluster
* EKS worker nodes
* ECR repositories
* Aurora MySQL database
* Security groups
* IAM resources

---

## Step 3: Connect kubectl to EKS

```bash
aws eks update-kubeconfig --region ap-south-1 --name book-review-dev
```

Check EKS nodes:

```bash
kubectl get nodes
```

---

## Step 4: Build Docker Images

Go back to the project root:

```bash
cd ../../..
```

Build frontend and backend images:

```bash
bash scripts/build-images.sh
```

Check Docker images:

```bash
docker images
```

---

## Step 5: Push Images to AWS ECR

Before running the script, make sure `scripts/push-images.sh` has the correct AWS account ID.

Then run:

```bash
bash scripts/push-images.sh
```

This pushes these images to AWS ECR:

```text
book-review-dev-frontend
book-review-dev-backend
```

---

## Step 6: Deploy the App to EKS

Before running the deploy script, update these values inside `scripts/deploy-k8s.sh`:

```bash
AWS_ACCOUNT_ID="your-aws-account-id"
DB_HOST="your-aurora-endpoint"
DB_PASS="your-database-password"
```

Get database values from Terraform:

```bash
cd terraform/environments/dev
terraform output -raw aurora_writer_endpoint
terraform output -raw aurora_password
cd ../../..
```

Deploy the app:

```bash
bash scripts/deploy-k8s.sh
```

---

## Step 7: Check Kubernetes Resources

Check all resources:

```bash
kubectl get all -n book-review
```

Check pods:

```bash
kubectl get pods -n book-review
```

Check services:

```bash
kubectl get svc -n book-review
```

---

## Step 8: Open the Application

Get the frontend LoadBalancer URL:

```bash
kubectl get svc frontend-service -n book-review
```

Copy the external URL and open it in your browser.

Example:

```text
http://your-load-balancer-url
```

---

## Useful Kubernetes Commands

Check backend logs:

```bash
kubectl logs -n book-review deployment/backend
```

Check frontend logs:

```bash
kubectl logs -n book-review deployment/frontend
```

Restart backend:

```bash
kubectl rollout restart deployment/backend -n book-review
```

Restart frontend:

```bash
kubectl rollout restart deployment/frontend -n book-review
```

Check backend API inside Kubernetes:

```bash
kubectl run curl-test -n book-review --rm -it --image=curlimages/curl -- sh
```

Inside the pod:

```bash
curl http://backend-service:5000/api/books
```

---

## Cleanup

Delete the Kubernetes application:

```bash
kubectl delete namespace book-review
```

Destroy AWS infrastructure:

```bash
cd terraform/environments/dev
terraform destroy
```

Type:

```text
yes
```

If ECR repositories cannot be deleted because they contain images, add this inside the ECR Terraform resources:

```hcl
force_delete = true
```

Then run:

```bash
terraform destroy
```

---

## Cost Warning

This project can cost money because it creates:

* EKS cluster
* EC2 worker nodes
* NAT Gateway
* Aurora database
* Load Balancer
* ECR repositories

Always destroy resources after practice to avoid unnecessary AWS charges.

---

## Project Status

This project is made for DevOps learning and portfolio practice.

It demonstrates:

* Docker image creation
* AWS infrastructure provisioning
* Kubernetes deployment
* Database connectivity
* Basic DevOps operations
