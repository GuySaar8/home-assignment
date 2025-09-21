# Infrastructure

This directory contains the Terraform configuration for the Hello World application infrastructure, providing a complete cloud-native environment on AWS.

## Overview

The infrastructure creates environment with:
- **VPC**: Multi-AZ networking with public, private, and database subnets
- **EKS Cluster**: Managed Kubernetes cluster for application workloads
- **RDS PostgreSQL**: Managed database with automated backups and security
- **Secrets Management**: Secure credential storage and distribution
- **OIDC Authentication**: GitHub Actions integration with temporary credentials
- **Security Groups**: Network-level access controls and isolation

## Terraform Modules Used

This infrastructure leverages community-maintained Terraform modules:

### 1. **VPC Module** (`terraform-aws-modules/vpc/aws ~> 5.0`)
- **Purpose**: Creates complete VPC networking infrastructure
- **Components**: VPC, subnets, route tables, gateways, security groups
- **Features**: Multi-AZ deployment, public/private/database subnet tiers
- **Configuration**:
  - CIDR: 10.0.0.0/16
  - Availability Zones: us-east-1a, us-east-1b
  - Private subnets for EKS worker nodes
  - Database subnets for RDS isolation
  - Public subnets for load balancers

### 2. **EKS Module** (`terraform-aws-modules/eks/aws ~> 20.0`)
- **Purpose**: Provisions managed Kubernetes cluster with best practices
- **Components**: Control plane, managed node groups, security groups, IAM roles
- **Features**:
  - Kubernetes v1.33
  - SPOT instances for cost optimization (t3.medium)
  - Auto-scaling (1-10 nodes)
  - OIDC integration for GitHub Actions
  - Cluster admin access for Terraform management

### 3. **RDS Module** (`terraform-aws-modules/rds/aws ~> 6.0`)
- **Purpose**: Manages PostgreSQL database with security and backup
- **Components**: DB instance, subnet group, parameter group, backups
- **Features**:
  - PostgreSQL 14 on db.t3.micro
  - 5GB storage (auto-scaling to 10GB)
  - 7-day backup retention
  - Custom password management
  - Network isolation in database subnets

## Resources Created

### Core Infrastructure

#### **VPC and Networking**
```
VPC (10.0.0.0/16)
├── Public Subnets (10.0.48.0/24, 10.0.49.0/24)
│   └── Internet Gateway access
├── Private Subnets (10.0.0.0/20, 10.0.16.0/20)
│   └── NAT Gateway for outbound traffic
├── Database Subnets (10.0.56.0/24, 10.0.57.0/24)
│   └── Isolated for RDS instances
└── Route Tables
    ├── Public routes (0.0.0.0/0 → IGW)
    ├── Private routes (0.0.0.0/0 → NAT)
    └── Database routes (local VPC only)
```

#### **EKS Cluster**
```
EKS Cluster (main-eks)
├── Control Plane (Kubernetes 1.33)
├── Managed Node Group
│   ├── Instance Type: t3.medium
│   ├── Capacity Type: SPOT (cost optimization)
│   └── Scaling: 1-10 nodes
├── Security Groups
│   ├── Cluster Security Group
│   └── Node Security Group
└── Access Control
    ├── Cluster Creator Admin
    └── GitHub Actions RBAC
```

#### **RDS Database**
```
PostgreSQL Instance
├── Engine: PostgreSQL 14
├── Instance: db.t3.micro
├── Storage: 5GB → 10GB (auto-scaling)
├── Database: hello_world
├── User: hello_world_user
├── Port: 5432
├── Backups: 7-day retention
└── Security: VPC isolated, EKS-only access
```

### Security Components

#### **Secrets Management**
- **AWS Secrets Manager**: Stores database credentials
- **Random Password**: Generated with safe special characters
- **Kubernetes Secrets**: Auto-created in dev/prd namespaces
- **Secret Rotation**: Ready for automated rotation

#### **Identity and Access**
- **OIDC Provider**: GitHub Actions federation
- **IAM Roles**:
  - EKS Service Role
  - EKS Node Group Role
  - GitHub Actions Role (AssumeRoleWithWebIdentity)
- **Security Groups**: Network access control
- **RBAC**: Kubernetes role-based permissions

#### **Network Security**
```
Security Group Rules:
├── RDS Security Group
│   ├── Ingress: Port 5432 from EKS Cluster SG
│   ├── Ingress: Port 5432 from EKS Node SG
│   └── Egress: All outbound
├── EKS Cluster Security Group (managed)
└── EKS Node Security Group (managed)
```

## File Structure

```
infra/
├── main.tf              # VPC and EKS module configurations
├── database.tf          # RDS module and database security group
├── secrets.tf           # Password generation and Secrets Manager
├── k8s-secrets.tf       # Kubernetes secrets for database connection
├── namespaces.tf        # Kubernetes namespaces (dev/prd)
├── iam-roles.tf         # IAM roles and policies for services
├── oidc.tf              # OIDC provider for GitHub Actions
├── providers.tf         # Terraform and AWS provider configuration
└── README.md            # This documentation
```

## Deployment Guide

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform >= 1.0 installed
- kubectl installed for cluster management

### Step-by-Step Deployment

1. **Initialize Terraform**:
   ```bash
   cd infra/
   terraform init
   ```

2. **Review the Plan**:
   ```bash
   terraform plan
   ```

3. **Deploy Infrastructure**:
   ```bash
   terraform apply
   ```

4. **Configure kubectl** (post-deployment):
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name main-eks
   ```

5. **Verify Deployment**:
   ```bash
   kubectl get nodes
   kubectl get namespaces
   ```

### Infrastructure Outputs
- **EKS Cluster Endpoint**: For kubectl configuration
- **RDS Endpoint**: Database connection endpoint
- **VPC ID**: For additional resource deployment
- **Subnet IDs**: For application load balancers

## Terraform State Management

For production environments, consider:
- **S3 Backend**: Store state in S3 bucket with DynamoDB locking
- **Managed Solutions**: Use platforms like **env0** or **Terraform Cloud** for better state management and automation
- **Security**: Never commit `terraform.tfstate` to version control (contains sensitive data like passwords/keys, causes merge conflicts, can corrupt infrastructure state, and exposes internal resource IDs)

## Cleanup and Destruction

### Safe Cleanup Process
**Destroy Infrastructure**:
   ```bash
   terraform destroy
   ```
