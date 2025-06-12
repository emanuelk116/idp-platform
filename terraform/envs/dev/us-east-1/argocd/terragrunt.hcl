terraform {
  source = "../../../modules/argocd"
}

dependencies {
  paths = ["../eks"]
}

dependency "eks" {
  config_path = "../eks"
}

inputs = {
  cluster_endpoint     = dependency.eks.outputs.cluster_endpoint
  cluster_ca           = dependency.eks.outputs.kubeconfig["cluster_ca_certificate"]
  cluster_auth_token   = trimspace(run_cmd("aws", "eks", "get-token", "--cluster-name", "idp-dev", "--query", "status.token", "--output", "text"))
}
