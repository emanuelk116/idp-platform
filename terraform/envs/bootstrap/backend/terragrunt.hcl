terraform {
  source = "../../../modules/backend"
}

inputs = {
  region          = "us-east-1"
  bucket_name     = "idp-terraform-states"
  lock_table_name = "terraform-locks"
}
