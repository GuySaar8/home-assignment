resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }

  depends_on = [module.eks]
}

resource "kubernetes_namespace" "prd" {
  metadata {
    name = "prd"
  }

  depends_on = [module.eks]
}
