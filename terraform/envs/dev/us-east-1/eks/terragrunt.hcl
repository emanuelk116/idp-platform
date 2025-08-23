terraform {
  source = "../../../../modules/eks"
}

include {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = [
    "../networking",
  ]
}

dependency "networking" {
  config_path = "../networking"
}

inputs = {
  region              = "us-east-1"
  env                 = "dev"
  cluster_name        = "idp-dev"
  cluster_version     = "1.33"
  vpc_id              = dependency.networking.outputs.vpc_id
  private_subnet_ids   = dependency.networking.outputs.private_subnet_ids
}