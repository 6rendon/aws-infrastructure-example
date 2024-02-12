include "root" {
  path   = "${dirname(get_path_to_repo_root())}/live.hcl"
  expose = true
}

include "envcommon" {
  path   = "${dirname(get_path_to_repo_root())}/_envcommon/aws-alb.hcl"
  expose = true
}

locals {
  common_vars = yamldecode(file("${get_terragrunt_dir()}/alb.yml"))
}

# ---------------------------------------------------------------------------------------------------------------------
# ALB MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  env      = local.common_vars.env
  vpc_name = local.common_vars.vpc_name
  app_name = local.common_vars.app_name
  ingress_security_group_rules = [
    {
      from_port   = local.common_vars.app_port
      to_port     = local.common_vars.app_port
      protocol    = "tcp"
      description = "WSS port"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}