include "root" {
  path   = find_in_parent_folders("management.hcl")
  expose = true
}

include "envcommon" {
  path   = find_in_parent_folders("_envcommon/aws-identity-center-permission-set.hcl")
  expose = true
}

locals {
  management_account_id = "${include.root.locals.aws_account_id}"
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS IDENTITY CENTER PERMISSION SET MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  name        = "GlobalAdminsAccess"
  group_name  = "GlobalAdmins"
  description = "Provides full access to AWS services and resources across all AWS accounts."
  managed_policies = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  management_account_id = local.management_account_id
  account_ids = [
    "123456789012",
    "234567890123",
    "345678901234"
  ]
}