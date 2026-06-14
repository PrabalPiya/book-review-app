# Book Review App

A full-stack Book Review web application built with:

* **Frontend:** Next.js, React, Axios
* **Backend:** Node.js, Express.js, Sequelize
* **Database:** MySQL-compatible database
* **Containerization:** Docker
* **Deployment:** Kubernetes, AWS EKS, AWS ECR, Aurora MySQL, Terraform

The application allows users to view books, register/login, and submit reviews for books.

---

## Project Structure

```bash
book-review-app/
├── backend/
│   ├── src/
│   │   ├── config/
│   │   │   └── db.js
│   │   ├── controllers/
│   │   │   ├── bookController.js
│   │   │   ├── reviewController.js
│   │   │   └── userController.js
│   │   ├── middleware/
│   │   │   └── authMiddleware.js
│   │   ├── models/
│   │   │   ├── Book.js
│   │   │   ├── Review.js
│   │   │   └── User.js
│   │   ├── routes/
│   │   │   ├── bookRoutes.js
│   │   │   ├── reviewRoutes.js
│   │   │   └── userRoutes.js
│   │   └── server.js
│   ├── Dockerfile
│   └── package.json
│
├── frontend/
│   ├── src/
│   │   ├── app/
│   │   ├── components/
│   │   ├── context/
│   │   └── services/
│   │       └── api.js
│   ├── Dockerfile
│   └── package.json
│
├── kubernetes/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── hpa.yaml
│   └── ingress.yaml
│
├── scripts/
│   ├── build-images.sh
│   ├── push-images.sh
│   ├── deploy-k8s.sh
│   └── cleanup.sh
│
├── terraform/
│   ├── environments/
│   │   └── dev/
│   └── modules/
│
└── .gitignore
```

---

## Features

* View available books
* View book details
* Register new users
* Login with JWT authentication
* Submit reviews for books
* Store users, books, and reviews in MySQL
* Automatic database table creation using Sequelize
* Sample data insertion when database tables are empty
* Docker support for frontend and backend
* Kubernetes deployment support
* AWS infrastructure support using Terraform

---

## Prerequisites

Install the following tools before running the project:

```bash
node -v
npm -v
docker --version
git --version
```

Recommended versions:

* Node.js 20 or newer
* npm 10 or newer
* MySQL 8 or MySQL-compatible database
* Docker Desktop, if using containers
* kubectl, AWS CLI, and Terraform, if deploying to AWS/EKS

---

## Clone the Repository

```bash
git clone https://github.com/PrabalPiya/book-review-app.git
cd book-review-app
```

---

# Running the Project Locally

The project has two main parts:

* Backend API runs on port `5000`
* Frontend web app runs on port `3000`

---

## 1. Start MySQL Database

You need a MySQL database before starting the backend.

### Option A: Use Docker MySQL

```bash
docker run --name book-review-mysql \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=bookreviewdb \
  -e MYSQL_USER=bookuser \
  -e MYSQL_PASSWORD=bookpass \
  -p 3306:3306 \
  -d mysql:8.0
```

Check if the container is running:

```bash
docker ps
```

---

## 2. Configure Backend Environment Variables

Go to the backend folder:

```bash
cd backend
```

Create a `.env` file:

```bash
touch .env
```

Add the following content:

```env
PORT=5000

DB_HOST=localhost
DB_PORT=3306
DB_NAME=bookreviewdb
DB_USER=bookuser
DB_PASS=bookpass

JWT_SECRET=your_super_secret_key

ALLOWED_ORIGINS=http://localhost:3000
```

Important:

The current backend database configuration uses SSL for MySQL connections. This is useful for cloud databases such as AWS Aurora or Azure MySQL. For local MySQL, if you get an SSL-related database connection error, update `backend/src/config/db.js` to make SSL optional.

Example safer local/cloud-compatible version:

```js
const { Sequelize } = require("sequelize");
require("dotenv").config();

const useSsl = process.env.DB_SSL === "true";

const sequelizeOptions = {
  host: process.env.DB_HOST,
  dialect: "mysql",
  port: process.env.DB_PORT || 3306,
  logging: false,
};

if (useSsl) {
  sequelizeOptions.dialectOptions = {
    ssl: {
      require: true,
      rejectUnauthorized: false,
    },
  };
}

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASS,
  sequelizeOptions
);

async function initializeDatabase() {
  try {
    await sequelize.authenticate();
    console.log(`Database '${process.env.DB_NAME}' connected successfully!`);
    return sequelize;
  } catch (error) {
    console.error("Database initialization failed:", error);
    process.exit(1);
  }
}

module.exports = initializeDatabase;
```

Then add this to your `.env` for local MySQL:

```env
DB_SSL=false
```

For AWS Aurora/RDS with SSL:

```env
DB_SSL=true
```

---

## 3. Install and Run Backend

Inside the `backend` folder:

```bash
npm install
node src/server.js
```

The backend should start on:

```bash
http://localhost:5000
```

Test the backend:

```bash
curl http://localhost:5000
```

Expected response:

```bash
Book Review API is running...
```

Test books API:

```bash
curl http://localhost:5000/api/books
```

---

## 4. Configure Frontend Environment Variables

Open a new terminal and go to the frontend folder:

```bash
cd frontend
```

Create a `.env.local` file:

```bash
touch .env.local
```

Add:

```env
NEXT_PUBLIC_API_URL=http://localhost:5000
```

This is important because the backend runs on port `5000`.

---

## 5. Install and Run Frontend

Inside the `frontend` folder:

```bash
npm install
npm run dev
```

The frontend should run on:

```bash
http://localhost:3000
```

Open the browser and visit:

```bash
http://localhost:3000
```

---

# API Endpoints

## Health Check

```http
GET /
```

## Users

```http
POST /api/users/register
POST /api/users/login
```

Example register request:

```bash
curl -X POST http://localhost:5000/api/users/register \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Test User\",\"email\":\"test@example.com\",\"password\":\"password123\"}"
```

Example login request:

```bash
curl -X POST http://localhost:5000/api/users/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"test@example.com\",\"password\":\"password123\"}"
```

## Books

```http
GET /api/books
GET /api/books/:id
POST /api/books
```

Example:

```bash
curl http://localhost:5000/api/books
```

## Reviews

```http
GET /api/reviews/:bookId
POST /api/reviews
```

Submitting a review requires a JWT token.

Example:

```bash
curl -X POST http://localhost:5000/api/reviews \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d "{\"bookId\":1,\"comment\":\"Great book!\",\"rating\":5}"
```

---

# Running with Docker

## 1. Build Backend Image

From the project root:

```bash
docker build -t book-review-backend:latest ./backend
```

## 2. Build Frontend Image

```bash
docker build \
  --build-arg NEXT_PUBLIC_API_URL=http://localhost:5000 \
  -t book-review-frontend:latest \
  ./frontend
```

## 3. Run Backend Container

```bash
docker run --name book-review-backend \
  -p 5000:5000 \
  --env-file backend/.env \
  book-review-backend:latest
```

## 4. Run Frontend Container

```bash
docker run --name book-review-frontend \
  -p 3000:3000 \
  book-review-frontend:latest
```

Frontend:

```bash
http://localhost:3000
```

Backend:

```bash
http://localhost:5000
```

---

# Using the Provided Scripts

Make scripts executable first:

```bash
chmod +x scripts/*.sh
```

## Build Docker Images

```bash
./scripts/build-images.sh
```

This builds:

```bash
book-review-backend:latest
book-review-frontend:latest
```

## Push Docker Images to AWS ECR

Before running the push script, export your AWS account ID:

```bash
export AWS_ID=123456789012
```

Then run:

```bash
./scripts/push-images.sh
```

The script expects these ECR repositories to exist:

```bash
book-review-dev-frontend
book-review-dev-backend
```

---

# Kubernetes Deployment

The Kubernetes files are inside the `kubernetes/` folder.

The app uses:

* Namespace: `book-review`
* Backend Deployment
* Frontend Deployment
* Backend ClusterIP Service
* Frontend LoadBalancer Service
* HPA for frontend and backend
* Optional AWS ALB Ingress

---

## 1. Create Kubernetes Secret Manually

Before deploying, create the database secret:

```bash
kubectl create namespace book-review
```

```bash
kubectl create secret generic book-review-db-secret \
  --namespace book-review \
  --from-literal=DB_USER=admin \
  --from-literal=DB_PASS=your_database_password
```

---

## 2. Update ConfigMap

Open:

```bash
kubernetes/configmap.yaml
```

Change these values:

```yaml
DB_HOST: "CHANGE_ME_DB_HOST"
DB_NAME: "CHANGE_ME_DB_NAME"
ALLOWED_ORIGINS: ""
```

Example:

```yaml
DB_HOST: "your-aurora-endpoint.amazonaws.com"
DB_NAME: "bookreviewdb"
ALLOWED_ORIGINS: "http://your-frontend-url"
```

---

## 3. Apply Kubernetes Manifests

```bash
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/configmap.yaml
kubectl apply -f kubernetes/backend-deployment.yaml
kubectl apply -f kubernetes/backend-service.yaml
kubectl apply -f kubernetes/frontend-deployment.yaml
kubectl apply -f kubernetes/frontend-service.yaml
kubectl apply -f kubernetes/hpa.yaml
```

Check resources:

```bash
kubectl get all -n book-review
```

Check logs:

```bash
kubectl logs -n book-review deployment/backend
kubectl logs -n book-review deployment/frontend
```

---

## 4. Access the Frontend

Get the frontend LoadBalancer URL:

```bash
kubectl get svc frontend-service -n book-review
```

Open the `EXTERNAL-IP` or hostname in your browser.

---

# AWS EKS Deployment with Provided Script

The repo includes a deployment script:

```bash
scripts/deploy-k8s.sh
```

Before running it, set these environment variables:

```bash
export AWS_ID=123456789012
export AURORA_ENDPOINT=your-aurora-writer-endpoint.amazonaws.com
export DB_PASS=your_database_password
```

Then run:

```bash
chmod +x scripts/deploy-k8s.sh
./scripts/deploy-k8s.sh
```

Check deployment:

```bash
kubectl get all -n book-review
```

---

# Terraform Infrastructure

Terraform code is located in:

```bash
terraform/environments/dev
```

It creates AWS infrastructure such as:

* VPC
* Public subnets
* Private subnets
* Database subnets
* ECR repositories
* EKS cluster
* EKS worker nodes
* Security groups
* Aurora MySQL
* IAM policy for automation

---

## Important Terraform Backend Note

The Terraform backend uses S3 and DynamoDB for remote state locking.

Before running Terraform, make sure this S3 bucket and DynamoDB table already exist:

```bash
S3 bucket: book-review-terraform-state-pocky
DynamoDB table: book-review-terraform-locks
```

If they do not exist, either create them manually or update:

```bash
terraform/environments/dev/backend.tf
```

---

## Run Terraform

```bash
cd terraform/environments/dev
terraform init
terraform validate
terraform plan
terraform apply
```

After apply, view outputs:

```bash
terraform output
```

Get sensitive outputs:

```bash
terraform output aurora_password
```

Update kubeconfig for EKS:

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name book-review-dev
```

---

# Cleanup

## Delete Kubernetes Application

```bash
kubectl delete namespace book-review
```

## Destroy Terraform Infrastructure

```bash
cd terraform/environments/dev
terraform destroy
```

Or use the cleanup script:

```bash
chmod +x scripts/cleanup.sh
./scripts/cleanup.sh
```

Warning:

`terraform destroy` deletes AWS infrastructure managed by Terraform. Use it carefully.

---

# Common Issues and Fixes

## 1. Frontend cannot connect to backend

Check `frontend/.env.local`:

```env
NEXT_PUBLIC_API_URL=http://localhost:5000
```

Then restart frontend:

```bash
npm run dev
```

---

## 2. CORS error

Check backend `.env`:

```env
ALLOWED_ORIGINS=http://localhost:3000
```

If deployed, add your frontend URL:

```env
ALLOWED_ORIGINS=http://localhost:3000,http://your-frontend-url
```

Restart backend after changing this.

---

## 3. Database connection failed

Check:

```env
DB_HOST
DB_PORT
DB_NAME
DB_USER
DB_PASS
DB_SSL
```

For local MySQL:

```env
DB_SSL=false
```

For AWS Aurora/RDS:

```env
DB_SSL=true
```

---

## 4. Backend starts but frontend shows no books

Test backend directly:

```bash
curl http://localhost:5000/api/books
```

If this works, the issue is usually frontend API URL configuration.

---

## 5. `npm start` does not work in backend

The backend package may not have a `start` script. Use:

```bash
node src/server.js
```

Or add this inside `backend/package.json`:

```json
"scripts": {
  "start": "node src/server.js"
}
```

Then run:

```bash
npm start
```

---

## 6. Kubernetes image pull error

If pods show `ImagePullBackOff` or `ErrImagePull`, check:

```bash
kubectl describe pod POD_NAME -n book-review
```

Common causes:

* Docker image was not pushed to ECR
* Wrong AWS account ID
* Wrong image name
* EKS node role does not have permission to pull from ECR

---

# Useful Commands

## Backend

```bash
cd backend
npm install
node src/server.js
```

## Frontend

```bash
cd frontend
npm install
npm run dev
```

## Docker

```bash
docker build -t book-review-backend:latest ./backend
docker build -t book-review-frontend:latest ./frontend
docker images
```

## Kubernetes

```bash
kubectl get all -n book-review
kubectl logs -n book-review deployment/backend
kubectl logs -n book-review deployment/frontend
kubectl delete namespace book-review
```

## Terraform

```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
terraform destroy
```

---

# Recommended Improvements

The current project works as a learning DevOps project, but these improvements would make it more production-ready:

* Add a proper backend `start` script in `package.json`
* Add `.env.example` files for backend and frontend
* Make database SSL configurable using `DB_SSL`
* Add Docker Compose for local frontend, backend, and MySQL
* Add proper health endpoint such as `/health`
* Add input validation for API requests
* Add automated tests
* Add CI/CD pipeline for build, test, push, and deploy
* Avoid using `latest` image tags in production
* Use Kubernetes Secrets for all sensitive values
* Use HTTPS in production
* Add monitoring and logging

---

# License

This project is currently for learning and demonstration purposes. Add a license file if you plan to publish or reuse it publicly.
