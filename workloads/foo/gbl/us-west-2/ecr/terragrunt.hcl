include "root" {
  path   = find_in_parent_folders("workloads.hcl")
  expose = true
}

include "envcommon" {
  path   = find_in_parent_folders("_envcommon/aws-ecr.hcl")
  expose = true
}

locals {
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ECR MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  names = [
    "foo/server"
  ]
}