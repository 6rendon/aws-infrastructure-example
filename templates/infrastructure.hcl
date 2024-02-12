include "root" {
  path   = find_in_parent_folders("source.hcl")
  expose = true
}

include "envcommon" {
  path   = find_in_parent_folders("_envcommon/template.hcl")
  expose = true
}

locals {
  organization = "${include.root.locals.organization}"
  environment  = "${include.root.locals.environment}"
}

# ---------------------------------------------------------------------------------------------------------------------
# TEMPLATE MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  organization = local.organization
  environment  = local.environment
}