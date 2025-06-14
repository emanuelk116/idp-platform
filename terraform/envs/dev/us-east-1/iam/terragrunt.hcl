terraform {
  source = "../../../../modules/iam"
}

include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  name_prefix = "dev"
}
