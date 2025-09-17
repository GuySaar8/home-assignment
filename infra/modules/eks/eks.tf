# EKS module: EKS cluster and worker nodes

resource "aws_eks_cluster" "primary" {
  name     = "primary"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

resource "aws_iam_role" "eks_cluster" {
  name               = "eksClusterRole"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.primary.name
  node_group_name = "main-eks-nodes"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids
  instance_types  = ["t3.micro"]
  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
}

resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "eks-node-lt-"
  image_id      = data.aws_ami.eks_worker.id
  instance_type = "t3.micro"
}

data "aws_ami" "eks_worker" {
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI account
  filter {
    name   = "name"
    values = ["amazon-eks-node-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
resource "aws_iam_role" "eks_nodes" {
  name               = "eksNodeRole"
  assume_role_policy = data.aws_iam_policy_document.eks_nodes_assume_role.json
}

data "aws_iam_policy_document" "eks_nodes_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

variable "subnet_ids" { type = list(string) }
