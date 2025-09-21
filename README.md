# DevOps Home Assignment

## Overview
This project demonstrates a complete DevOps workflow for deploying a Python Flask web application with PostgreSQL database integration.

It includes:
- Containerized Python Flask application
- Infrastructure as Code using Terraform
- CI/CD pipeline with GitHub Actions
- Kubernetes deployment using Helm
- Environment-specific deployments (dev/prd)
- Automated PR environment

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

When prompted, provide:
- **AWS Access Key ID**: Your AWS access key
- **AWS Secret Access Key**: Your AWS secret key
- **Default region name**: `us-east-1` (this project is configured for US East 1)
- **Default output format**: `json` (recommended)

Required AWS IAM permissions for your user/role:
- **EKS**: Create and manage EKS clusters, node groups, and access entries
- **VPC/Networking**: Create VPCs, subnets, internet gateways, NAT gateways, route tables
- **IAM**: Create and manage roles, policies, and OIDC providers for EKS and GitHub Actions
- **EC2**: Create security groups, launch templates, and manage EC2 instances for EKS nodes
- **RDS**: Create and manage PostgreSQL database instances, parameter groups, and subnet groups
- **Secrets Manager**: Create and manage database credentials and other sensitive data
- **KMS**: Create and manage encryption keys for EKS and RDS

> For simplicity during setup, you can use a user with `AdministratorAccess` policy. For production environments, create a more restrictive custom policy with only the specific permissions needed.

### Step 2: Fork and Configure Repository
1. Fork this repository
2. Update Docker repository configuration in `.github/workflows/ci-cd.yaml`:
   ```yaml
   env:
     docker-registry: YOUR-DOCKERHUB-USERNAME/hello-world  # Must match values.yaml repository
   ```

   Make sure both files use the same repository name to ensure CI/CD pushes images to the correct location.
3. Configure GitHub Secrets:
   ```
   DOCKERHUB_USERNAME
   DOCKERHUB_TOKEN
   ```

   Note: AWS authentication now uses OpenID Connect (OIDC) for enhanced security instead of static access keys.

### Step 3: Deploy Infrastructure
```bash
cd infra
terraform init
terraform plan
terraform apply
```

Key Terraform resources created:
- **EKS cluster** with OIDC provider and access entries
- **VPC** with public/private/database subnets across 2 AZs
- **EKS managed node groups** with t3.medium spot instances
- **PostgreSQL RDS instance** (db.t3.micro) with automated backups
- **AWS Secrets Manager** secrets for database credentials
- **Kubernetes secrets** for database connection (managed by Terraform)
- **Security groups** for EKS cluster, worker nodes, and RDS access
- **IAM roles and policies** for EKS, node groups, and GitHub Actions OIDC
- **KMS keys** for EKS and RDS encryption
- **Kubernetes namespaces** (dev/prd) with proper RBAC

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

## Testing

The project includes comprehensive testing at multiple levels:

### Python Application Tests
Tests are run in a containerized environment using Python 3.11:
```bash
# Run via pre-commit
pre-commit run python-tests

# Run manually in container
docker run -v ./src:/src python:3.11-slim /bin/sh -c "cd /src && pip install -r requirements.txt -r requirements-dev.txt && python -m pytest tests/"
```

### Helm Chart Tests
Three levels of Helm testing are implemented:

1. **Helm Lint** - Validates chart structure and syntax:
   ```bash
   pre-commit run helm-lint
   # or
   helm lint ./helm-hello-world
   ```

2. **Template Validation** - Verifies template rendering:
   ```bash
   pre-commit run helm-template
   # or
   helm template ./helm-hello-world --debug
   ```

3. **Unit Tests** - Tests chart functionality:
   ```bash
   pre-commit run helm-unittest
   # or
   helm unittest ./helm-hello-world
   ```

Test coverage includes:
- Deployment configuration
- Service settings
- Environment variables
- Dynamic value substitution
- Resource specifications

### Terraform Tests
Automated infrastructure testing using multiple tools:

1. **Format Check** (`terraform fmt`)
2. **Validation** (`terraform validate`)
3. **Static Analysis** (`terraform tflint`)
4. **Documentation** (`terraform-docs`)

## Local Development

### Pre-commit Hooks
This project uses pre-commit hooks to ensure code quality and run tests before each commit. The hooks include:

1. **Python Tests** (Containerized)
   - Runs in Python 3.11 Docker container
   - Executes pytest suite
   - Validates application functionality
   - Ensures consistent test environment

2. **Terraform Validation**
   - Formats Terraform code
   - Validates Terraform configuration
   - Runs TFLint for additional checks
   - Updates Terraform documentation

3. **Helm Chart Testing** (Containerized)
   - Lints charts using `alpine/helm:3.12.3`
   - Validates template rendering with debug output
   - Runs unit tests via `quintush/helm-unittest:3.11.2`
   - Tests deployment, service, and configuration

4. **General Code Quality**
   - Checks YAML/JSON syntax
   - Fixes file endings
   - Removes trailing whitespace
   - Prevents large file commits

To set up pre-commit:
```bash
# Install pre-commit
pip install pre-commit

# Install the git hooks
pre-commit install

# Run against all files (optional)
pre-commit run --all-files
```

The hooks will run automatically on `git commit`. You can also run them manually with:
```bash
pre-commit run
```
