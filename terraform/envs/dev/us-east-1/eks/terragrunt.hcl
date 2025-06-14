terraform {
  source = "../../../../modules/eks"
}

include {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = [
    "../networking",
    "../iam"
  ]
}

dependency "networking" {
  config_path = "../networking"
}

dependency "iam" {
  config_path = "../iam"
}

inputs = {
  region            = "us-east-1"
  env               = "dev"
  cluster_name      = "idp-dev"
  cluster_version   = "1.29"
  vpc_id            = dependency.networking.outputs.vpc_id
  public_subnet_ids = dependency.networking.outputs.public_subnet_ids
  cluster_role_arn  = dependency.iam.outputs.eks_cluster_role_arn
  node_role_arn     = dependency.iam.outputs.eks_node_role_arn
}