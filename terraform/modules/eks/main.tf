terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids

  enable_irsa = true

  create_iam_role = false
  iam_role_arn    = var.cluster_role_arn

  eks_managed_node_groups = {
    default = {
      name          = "default-node-group"
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      iam_role_arn   = var.node_role_arn
    }
  }

  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}
