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
