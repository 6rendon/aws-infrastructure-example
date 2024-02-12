# The tenant directory structure is parsed for .hcl files
# The .hcl files are parsed for values used commonly amongst resource modules
locals {
  organization = "org"
  core_owner   = "user@example.com"
  # Automatically load module-level variables
  module_vars = read_terragrunt_config("${get_original_terragrunt_dir()}/owner.hcl", "empty.hcl")
  owner       = try(local.module_vars.locals.owner, local.core_owner)
  # Automatically load account-level variables
  account_vars   = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_name   = local.account_vars.locals.account_name
  aws_account_id = local.account_vars.locals.aws_account_id
  application    = local.account_vars.locals.application
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region  = local.region_vars.locals.aws_region
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment
  # Additional variables
  last_modified   = formatdate("DD MMM YYYY", timestamp())
  resource_prefix = "${local.organization}-${local.aws_region}-${local.environment}"
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"

  allowed_account_ids = [${local.aws_account_id}]

  skip_metadata_api_check = true
  skip_region_validation = true
  skip_credentials_validation = true

  default_tags {

    tags = {
      "org:Owner"             = "${local.owner}"
      "org:Environment"       = "${local.environment}"
      "org:Application"       = "${local.application}"
      "org:ManagedBy"         = "Terraform"
      "TerraformPath"         = "${path_relative_to_include()}"
      "TerraformLastModified" = "${local.last_modified}"
    }

  }

}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt = true
    bucket  = "${local.aws_account_id}-${local.resource_prefix}-terraform-state"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = local.aws_region

    skip_credentials_validation = true
    skip_metadata_api_check     = true

    s3_bucket_tags = {
      "org:Owner"       = "${local.core_owner}"
      "org:Environment" = "${local.environment}"
      "org:Application" = "core"
      "org:ManagedBy"   = "Terragrunt"
    }
    dynamodb_table = "${local.resource_prefix}-terraform-locks"
    dynamodb_table_tags = {
      "org:Owner"       = "${local.core_owner}"
      "org:Environment" = "${local.environment}"
      "org:Application" = "core"
      "org:ManagedBy"   = "Terragrunt"
    }
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)