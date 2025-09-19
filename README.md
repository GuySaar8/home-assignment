# DevOps Home Assignment: Hello World Solution

## Overview
This project demonstrates a complete DevOps workflow for deploying a minimal Python Flask "Hello World" web application to AWS EKS using modern infrastructure-as-code, containerization, Helm, and CI/CD automation.

## Solution Architecture
- **Application:** Python Flask app with a single endpoint.
- **Containerization:** Dockerfile for consistent builds and deployment.
- **Infrastructure:** Terraform modules provision AWS VPC, subnets, Internet Gateway, and an EKS cluster.
- **Deployment:** Custom Helm chart for Kubernetes deployment and service exposure.
- **Automation:** GitHub Actions CI/CD pipeline automates build, push, and deployment.

## Setup Instructions

### Prerequisites
- AWS account with permissions for EKS, EC2, VPC, IAM, etc.
- Docker installed locally
- Terraform installed locally
- Helm installed locally
- GitHub repository with required secrets for CI/CD

### Steps
1. **Clone the repository:**
	```bash
	git clone https://github.com/GuySaar8/home-assignment.git
	cd home-assignment
	```
2. **Build and run locally:**
	```bash
	pip install -r requirements.txt
	python app.py
	# Visit http://localhost:5000
	```
3. **Build Docker image:**
	```bash
	docker build -t guysaar8/comet-home:latest .
	docker run -p 5000:5000 guysaar8/comet-home:latest
	```
4. **Provision AWS infrastructure:**
	```bash
	cd infra
	terraform init
	terraform apply
	# Confirm when prompted
	```
5. **Push Docker image to Docker Hub:**
	```bash
	docker login
	docker push guysaar8/comet-home:latest
	```
6. **Deploy with Helm:**
	```bash
	helm install hello-world ./helm-hello-world --set image.repository=guysaar8/comet-home --set image.tag=latest
	```

## CI/CD Pipeline (GitHub Actions)
- **Trigger:** On push to `main` branch
- **Build and Push Job:**
  - Checks out code
  - Builds Docker image from Dockerfile
  - Pushes image to Docker Hub (`guysaar8/comet-home:latest`)
- **Deploy Job:**
  - Configures AWS credentials
  - Sets up `kubectl` and Helm
  - Updates kubeconfig for EKS
  - Deploys/updates the app using Helm chart

Secrets required:
- `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` for Docker Hub authentication
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_REGION` for AWS access

## Deployment Flow
1. **Code Commit:** Developer pushes code to GitHub.
2. **CI/CD Trigger:** GitHub Actions workflow starts.
3. **Build & Push:** Docker image is built and pushed to Docker Hub.
4. **Deploy:** Helm chart deploys the new image to EKS cluster.
5. **Production:** The app is available via the Kubernetes LoadBalancer and Ingress.

## Additional Notes
- All infrastructure and deployment steps are automated and repeatable.
- Subnets and instance types are configured for high availability and compatibility.
- PR naming conventions and RC versioning are supported (see comments in workflow and READMEs).

---
For any issues, please open an issue in the repository or contact the maintainer.
