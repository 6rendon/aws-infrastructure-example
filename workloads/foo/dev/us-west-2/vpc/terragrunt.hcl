include "root" {
  path   = find_in_parent_folders("workloads.hcl")
  expose = true
}

include "envcommon" {
  path   = find_in_parent_folders("_envcommon/aws-vpc.hcl")
  expose = true
}

locals {
  organization = "${include.root.locals.organization}"
  environment  = "${include.root.locals.environment}"
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  organization       = local.organization
  environment        = local.environment
  cidr               = "10.123.0.0/16"
  azs_count          = 2
  single_nat_gateway = true
}