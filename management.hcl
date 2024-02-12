# The tenant directory structure is parsed for .hcl files
# The .hcl files are parsed for values used commonly amongst resource modules
locals {
  organization = "org"
  # Account-level variables
  aws_account_id = "123456789012"
  owner          = "user@example.com"
  # Region-level variables
  aws_region = "us-east-1"
  # Environment-level variables
  environment = "gbl"
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
      "org:Application"       = "CORE"
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
      "org:Owner"       = "${local.organization}"
      "org:Environment" = "${local.environment}"
      "org:Application" = "core"
      "org:ManagedBy"   = "Terragrunt"
    }
    dynamodb_table = "${local.resource_prefix}-terraform-locks"
    dynamodb_table_tags = {
      "org:Owner"       = "${local.organization}"
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
)