################################################################################
# GitHub Actions IAM Role for EKS Deployment
################################################################################

# Create trust policy for GitHub Actions
data "aws_iam_policy_document" "github_actions_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:GuySaar8/home-assignment:*"]
    }
  }
}

# Create IAM role for GitHub Actions with EKS deployment permissions
resource "aws_iam_role" "github_actions" {
  name               = "github-actions-eks-deployer-${local.tags.Environment}"
  description        = "Role for GitHub Actions to deploy to EKS cluster"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_policy.json

  tags = local.tags
}

# Custom policy for EKS deployment permissions
resource "aws_iam_policy" "github_actions_eks_deploy" {
  name        = "github-actions-eks-deploy-${local.tags.Environment}"
  description = "EKS deployment permissions for GitHub Actions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:DescribeNodegroup",
          "eks:ListClusters",
          "eks:ListNodegroups"
        ]
        Resource = "*"
      }
    ]
  })

  tags = local.tags
}

# Attach the EKS deployment policy to the role
resource "aws_iam_role_policy_attachment" "github_actions_eks_deploy" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_eks_deploy.arn
}

################################################################################
# Outputs
################################################################################

output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions IAM role for EKS deployment"
  value       = aws_iam_role.github_actions.arn
}
