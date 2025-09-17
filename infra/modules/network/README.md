# Network Module

This module provisions the core networking infrastructure for the AWS environment.

## Resources Created

- **VPC (`aws_vpc.main`)**
  - Creates a new Virtual Private Cloud with CIDR block `10.0.0.0/16`.

- **Internet Gateway (`aws_internet_gateway.igw`)**
  - Provides internet access for resources in the VPC.

- **Public Subnets (`aws_subnet.public`)**
  - Two public subnets, each in a different availability zone.
  - Public IPs are assigned on launch.

- **Private Subnets (`aws_subnet.private`)**
  - Two private subnets, each in a different availability zone.
  - No public IPs assigned.

- **Availability Zones (`data.aws_availability_zones.available`)**
  - Dynamically selects available zones for subnet placement.

## Outputs
- `vpc_id`: The ID of the created VPC.
- `private_subnet_ids`: List of private subnet IDs for use by other modules (e.g., EKS).

---
This README is specific to the network module.
