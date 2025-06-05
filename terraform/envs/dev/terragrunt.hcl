locals {
  region = "us-east-1"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "idp-terraform-states"
    key            = "dev/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}