# EKS Module

This module provisions an Amazon Elastic Kubernetes Service (EKS) cluster and its worker nodes.

## Resources Created

- **EKS Cluster (`aws_eks_cluster.main`)**
  - Creates an EKS cluster in the provided VPC and subnets.
  - Uses an IAM role for cluster management.

- **IAM Role for Cluster (`aws_iam_role.eks_cluster`)**
  - Allows EKS to manage AWS resources.
  - Uses an assume role policy for EKS service.

- **EKS Node Group (`aws_eks_node_group.main`)**
  - Provisions two worker nodes for the cluster.
  - Uses an IAM role for EC2 instances.
  - Configures scaling (min, max, desired = 2).

- **IAM Role for Nodes (`aws_iam_role.eks_nodes`)**
  - Allows EC2 instances to join the EKS cluster.
  - Uses an assume role policy for EC2 service.

## Variables
- `vpc_id`: The VPC ID where the cluster is deployed.
- `subnet_ids`: List of subnet IDs for worker nodes.

---
This README is specific to the EKS module.
