resource "aws_iam_user" "deployment_user" {
  name = "deployment-user"
}

resource "aws_iam_user_policy_attachment" "eks_policy" {
  user       = aws_iam_user.deployment_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_user_policy_attachment" "ecr_policy" {
  user       = aws_iam_user.deployment_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_user_policy_attachment" "eks_describe_policy" {
  user       = aws_iam_user.deployment_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_access_key" "deployment_user_key" {
  user = aws_iam_user.deployment_user.name
}

output "deployment_user_access_key_id" {
  value       = aws_iam_access_key.deployment_user_key.id
  description = "Access Key ID for the deployment user"
  sensitive   = true
}

output "deployment_user_secret_access_key" {
  value       = aws_iam_access_key.deployment_user_key.secret
  description = "Secret Access Key for the deployment user"
  sensitive   = true
}