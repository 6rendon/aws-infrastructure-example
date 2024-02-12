include "root" {
  path   = find_in_parent_folders("management.hcl")
  expose = true
}

include "envcommon" {
  path   = find_in_parent_folders("_envcommon/aws-identity-center-user.hcl")
  expose = true
}

locals {
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS IDENTITY CENTER USER MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  identity_center_users = [
    "user@example.com"
  ]
}