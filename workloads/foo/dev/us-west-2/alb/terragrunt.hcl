dependency "vpc" {
  config_path = "../vpc"
}

include "root" {
  path   = find_in_parent_folders("workloads.hcl")
  expose = true
}

include "envcommon" {
  path   = find_in_parent_folders("_envcommon/aws-alb.hcl")
  expose = true
}

locals {
  organization = "${include.root.locals.organization}"
  environment  = "${include.root.locals.environment}"
}

# ---------------------------------------------------------------------------------------------------------------------
# ALB MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  organization    = local.organization
  environment     = local.environment
  vpc_name        = dependency.vpc.outputs.name
  acm_domain_name = "example.com"
  access_logs_config = {
    create_bucket = false
    enabled       = false
  }
}