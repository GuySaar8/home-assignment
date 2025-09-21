locals {
  name     = "main-vpc"
  vpc_cidr = "10.0.0.0/16"
  azs      = ["us-east-1a", "us-east-1b"]
  tags = {
    Environment = "dev"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 56)]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  database_subnet_tags = {
    "purpose" = "rds"
  }

  tags = local.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "main-eks"
  cluster_version = "1.33"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true # Enable public access

  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
    capacity_type  = "SPOT"
  }

  eks_managed_node_groups = {
    main = {
      desired_size = 1
      max_size     = 10
      min_size     = 1
    }
  }

  # Enable cluster creator admin permissions so local Terraform can manage resources
  # Root account access already exists from cluster creation
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    github-actions = {
      principal_arn = aws_iam_role.github_actions.arn
      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = local.tags
}
