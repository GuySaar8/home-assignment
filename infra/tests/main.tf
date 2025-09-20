provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    test = {
      source = "terraform.io/builtin/test"
    }
  }
}

resource "test_assertions" "vpc" {
  component = "vpc"

  equal "cidr_block" {
    description = "VPC has correct CIDR"
    got         = module.vpc.vpc_cidr_block
    want        = "10.0.0.0/16"
  }

  check "subnet_count" {
    description = "VPC has correct number of subnets"
    condition   = length(module.vpc.private_subnets) > 0 && length(module.vpc.public_subnets) > 0
  }
}

resource "test_assertions" "eks" {
  component = "eks"

  check "cluster_version" {
    description = "EKS cluster version is supported"
    condition   = module.eks.cluster_version >= "1.24"
  }

  check "node_groups" {
    description = "EKS has node groups configured"
    condition   = length(module.eks.eks_managed_node_groups) > 0
  }
}