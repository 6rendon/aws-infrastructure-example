include "root" {
  path   = find_in_parent_folders("workloads.hcl")
  expose = true
}

include "envcommon" {
  path   = find_in_parent_folders("_envcommon/stack-workloads-base.hcl")
  expose = true
}

locals {
}

# ---------------------------------------------------------------------------------------------------------------------
# STACK WORKLOADS BASE MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
}