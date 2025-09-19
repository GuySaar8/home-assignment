provider "kubernetes" {
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.main.token
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }

  depends_on = [
    module.eks
  ]
}

resource "kubernetes_namespace" "prd" {
  metadata {
    name = "prd"
  }

  depends_on = [
    module.eks
  ]
}

data "aws_eks_cluster" "main" {
  name = "main-eks"
}

data "aws_eks_cluster_auth" "main" {
  name = data.aws_eks_cluster.main.name
}