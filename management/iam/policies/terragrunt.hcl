include "root" {
  path   = find_in_parent_folders("management.hcl")
  expose = true
}

include "envcommon" {
  path   = find_in_parent_folders("_envcommon/aws-iam-policy.hcl")
  expose = true
}

locals {
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS IAM POLICY MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  policies = [
    {
      name        = "cost-explorer-full-access"
      description = "This policy grants permissions for billing and cost management."
    }
  ]
  policies_path = "./"
}