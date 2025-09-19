# Infrastructure as Code: AWS with Terraform

This README explains the Terraform code for provisioning AWS infrastructure for the home assignment (Phase 2).

## What Has Been Done
- Modular Terraform code created under `infra/`.
- Provisions a VPC, public and private subnets, Internet Gateway, and an EKS cluster with two worker nodes.
- Code is split into modules for network and EKS resources.
- All resources include comments for clarity.

## How to Use

### Prerequisites
- Terraform installed ([Download](https://www.terraform.io/downloads.html))
- AWS CLI configured with credentials

### Steps

1. **Initialize Terraform**
   ```bash
   cd infra
   terraform init
   ```

2. **Review and Apply the Plan**
   ```bash
   terraform plan
   terraform apply
   ```
   Confirm when prompted to create resources.

3. **Clean Up**
   To destroy all resources:
   ```bash
   terraform destroy
   ```

## Structure
- `main.tf`: Root configuration, calls modules
- `modules/network/`: VPC, subnets, Internet Gateway
- `modules/eks/`: EKS cluster and worker nodes

---

This README is specific to the infrastructure code and is separate from the application README.
