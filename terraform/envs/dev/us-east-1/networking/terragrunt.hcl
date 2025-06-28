terraform {
  source = "../../../../modules/vpc"
}

include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  name                = "dev"
  cluster_name        = "idp-dev"
  region              = "us-east-1"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  azs                 = ["us-east-1a", "us-east-1b"]
}
