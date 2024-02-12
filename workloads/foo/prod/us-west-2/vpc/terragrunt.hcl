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
# AWS VPC MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  organization       = local.organization
  environment        = local.environment
  cidr               = "10.110.0.0/16"
  azs_count          = 3
  single_nat_gateway = true

  enable_flow_log                                 = true
  flow_log_destination_type                       = "cloud-watch-logs"
  flow_log_cloudwatch_log_group_kms_key_alias     = "cloudwatch/logs"
  flow_log_cloudwatch_log_group_retention_in_days = 7
  flow_log_max_aggregation_interval               = 600
}