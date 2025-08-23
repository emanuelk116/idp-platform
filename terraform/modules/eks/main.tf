terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com/"
}

data "aws_iam_user" "terraform_user" {
  user_name = "terraform-user"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.37.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  
  bootstrap_self_managed_addons = true
  cluster_addons = {
    vpc-cni = {}
    coredns = {}
    kube-proxy = {}
    aws-ebs-csi-driver = {}
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  access_entries = {
    admin-access = {
      principal_arn = data.aws_iam_user.terraform_user.arn
      
      policy_association = {
        cluster-admin = {
          policy_arn  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          acces_scope = "cluster" 
        }
      }
    }
  }

  eks_managed_node_groups = {
    default = {
      name           = "default-node-group"
      instance_types = ["t4g.small"]
      ami_type       = "AL2023_ARM_64_STANDARD"
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }

  cluster_endpoint_public_access           = true
  cluster_endpoint_public_access_cidrs = ["${chomp(trimspace(data.http.my_ip.response_body))}/32"]

  tags = {
    Environment = var.env
    Terraform   = "true"
  }

}