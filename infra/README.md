# Infrastructure Overview

This repository contains Terraform configurations for setting up a robust and scalable infrastructure on AWS. Below is a detailed explanation of the resources created and their purposes.

## Resources Created

### 1. **VPC (Virtual Private Cloud)**
The VPC module is used to create a Virtual Private Cloud that serves as the network foundation for the infrastructure. It includes the following components:

- **CIDR Block**: `10.0.0.0/16` (default, configurable via `local.vpc_cidr`)
- **Subnets**:
  - **Private Subnets**: Used for resources that should not be directly accessible from the internet.
  - **Public Subnets**: Used for resources that need internet access, such as load balancers.
  - **Intra Subnets**: Reserved for internal communication between resources.
- **NAT Gateway**: Enables private subnets to access the internet securely.
- **Tags**: Custom tags for resource identification.

### 2. **EKS (Elastic Kubernetes Service)**
The EKS module provisions a Kubernetes cluster and its associated worker nodes. It includes:

#### **EKS Cluster**
- **Name**: `primary`
- **Role**: IAM role (`eksClusterRole`) that allows the cluster to interact with other AWS services.
- **VPC Configuration**: Uses the private subnets created by the VPC module.

#### **EKS Node Group**
- **Cluster Name**: Associated with the EKS cluster.
- **Node Group Name**: `main-eks-nodes`
- **Instance Type**: `t2.micro` (default, configurable).
- **Scaling Configuration**:
  - Desired Size: 1
  - Minimum Size: 1
  - Maximum Size: 2
- **Capacity Type**: SPOT instances for cost efficiency.
- **Role**: IAM role (`eksNodeRole`) that allows nodes to interact with the cluster.

### 3. **IAM Roles**
IAM roles are created to provide the necessary permissions for the EKS cluster and its worker nodes:

- **EKS Cluster Role**:
  - Allows the cluster to assume roles and interact with AWS services.
  - Policy: `sts:AssumeRole` for `eks.amazonaws.com`.

- **EKS Node Role**:
  - Allows worker nodes to assume roles and interact with the cluster.
  - Policy: `sts:AssumeRole` for `ec2.amazonaws.com`.

### 4. **Networking**
The networking module handles the creation of subnets and routing configurations:

- **Private Subnets**: Used for internal resources.
- **Public Subnets**: Used for internet-facing resources.
- **Routing**: Configured to enable communication between subnets and external networks.

## Variables

### VPC Variables
- `local.name`: Name of the VPC.
- `local.vpc_cidr`: CIDR block for the VPC.
- `local.azs`: Availability zones for subnet distribution.
- `local.tags`: Tags for resource identification.

### EKS Variables
- `var.subnet_ids`: List of subnet IDs used by the EKS cluster.

## Outputs

### VPC Outputs
- **Private Subnet IDs**: Used by the EKS cluster.
- **Public Subnet IDs**: Used for load balancers.

### EKS Outputs
- **Cluster Name**: Name of the EKS cluster.
- **Node Group Name**: Name of the worker node group.

## Usage

1. Clone the repository.
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Plan the infrastructure:
   ```bash
   terraform plan
   ```
4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Notes

- Ensure that AWS credentials are configured before running Terraform commands.
- Adjust the `local` variables in `main.tf` to match your environment.
- Review the `terraform.tfstate` file for state management.

## License

This project is licensed under the MIT License. See the LICENSE file for details.