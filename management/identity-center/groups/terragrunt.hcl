include "root" {
  path   = find_in_parent_folders("management.hcl")
  expose = true
}

include "envcommon" {
  path   = find_in_parent_folders("_envcommon/aws-identity-center-group.hcl")
  expose = true
}

locals {
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS IDENTITY CENTER GROUP MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  identity_center_groups = {
    GlobalAdmins = {
      description = "Provides full access to AWS services and resources across all AWS accounts."
      users = [
        "user@example.com"
      ]
    }
  }
}