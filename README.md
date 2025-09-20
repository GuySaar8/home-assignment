# DevOps Home Assignment

## Overview
This project demonstrates a complete DevOps workflow for deploying a minimal Python Flask "Hello World" web application.

It includes:
- Containerized Python Flask application
- Infrastructure as Code using Terraform
- CI/CD pipeline with GitHub Actions
- Kubernetes deployment using Helm
- Environment-specific deployments (dev/prd)
- Automated PR environments with cleanup

## Project Structure
```
├── src/                    # Flask application source code
├── helm-hello-world/       # Helm chart for application deployment
├── infra/                  # Terraform infrastructure code
└── .github/workflows/      # GitHub Actions CI/CD pipelines
```

## Infrastructure Setup

### Prerequisites
- AWS CLI installed and configured
- Terraform installed
- kubectl installed
- Helm installed
- Docker installed
- GitHub account
- Docker Hub account

### Step 1: Configure Your AWS Account
```bash
aws configure
```

Required permissions:
- EKS cluster management
- VPC management
- IAM role/policy management
- Load Balancer management

### Step 2: Fork and Configure Repository
1. Fork this repository
2. Update Docker repository configuration in two places:

   a. In `helm-hello-world/values.yaml`:
   ```yaml
   image:
     repository: YOUR-DOCKERHUB-USERNAME/hello-world
   ```

   b. In `.github/workflows/ci-cd.yaml`:
   ```yaml
   env:
     docker-registry: YOUR-DOCKERHUB-USERNAME/hello-world  # Must match values.yaml repository
   ```

   Make sure both files use the same repository name to ensure CI/CD pushes images to the correct location.
3. Configure GitHub Secrets:
   ```
   AWS_ACCESS_KEY_ID
   AWS_SECRET_ACCESS_KEY
   AWS_REGION
   DOCKERHUB_USERNAME
   DOCKERHUB_TOKEN
   ```

### Step 3: Deploy Infrastructure
```bash
cd infra
terraform init
terraform plan
terraform apply
```

Key Terraform resources created:
- EKS cluster
- VPC with public/private subnets
- Node groups
- IAM roles and policies
- Security groups

### Step 4: Configure kubectl
```bash
aws eks update-kubeconfig --region YOUR-REGION --name main-eks
```

## CI/CD Pipeline

### Pull Request Workflow
1. Create a new branch and PR
2. Add `build-and-deploy` label to trigger deployment
3. Pipeline will:
   - Build Docker image
   - Tag as `pr{NUMBER}-{COMMIT}`
   - Push to Docker Hub
   - Deploy to dev namespace with unique name
   - URL: Generated ELB domain

### Production Deployment
1. Merge PR to main
2. Pipeline automatically:
   - Builds image
   - Tags with commit hash
   - Pushes to Docker Hub
   - Deploys to prd namespace

### Ingress Configuration
After your first deployment to each environment, you need to configure the ingress with the ALB endpoints:

1. Get the ALB URLs from AWS Console or using:
   ```bash
   kubectl get svc -n dev   # For dev environment
   kubectl get svc -n prd   # For production environment
   ```

2. Update `helm-hello-world/values.yaml` with the ALB endpoints:
   ```yaml
   ingress:
     hosts:
       - host:
           dev: YOUR-DEV-ALB-URL.us-east-1.elb.amazonaws.com
           prd: YOUR-PROD-ALB-URL.us-east-1.elb.amazonaws.com
         paths:
           - /
   ```

> **Production Best Practices Note**: 
> The manual ALB endpoint configuration is used here for simplicity. In a production environment, you would typically:
> 1. Install AWS Load Balancer Controller for better ALB integration
> 2. Use External-DNS controller to automatically manage DNS records
> 3. Configure a proper domain in Route53 instead of using raw ALB endpoints


## Application Features
- Environment-aware deployment
- Visual environment indicator (green=dev, red=prd)
- Unique PR deployments
- Load balanced access
