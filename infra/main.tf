# Root Terraform configuration

module "network" {
  source = "./modules/network"
}

module "eks" {
  source     = "./modules/eks"
  subnet_ids = module.network.private_subnet_ids
}
