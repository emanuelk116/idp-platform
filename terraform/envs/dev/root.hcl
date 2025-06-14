locals {
  region = "us-east-1"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "idp-terraform-states"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}