include "root" {
  path   = find_in_parent_folders("management.hcl")
  expose = true
}

include "envcommon" {
  path   = find_in_parent_folders("_envcommon/aws-organizational-units.hcl")
  expose = true
}

# ---------------------------------------------------------------------------------------------------------------------
# ORGANIZATION UNITS MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
}
// The following are applied default OUs
//   "Infrastructure" = {
//     "Production" = {}
//     "SDLC"       = {}
//   }
//   "Workloads" = {
//     "Production" = {}
//     "SDLC"       = {}
//   }
//   "Suspended" = {}
//   "Security"  = {}
//   "Sandbox"   = {}
// }