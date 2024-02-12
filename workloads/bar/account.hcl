# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "BARAccount"
  aws_account_id = "123456789012"
  application    = "bar"
}
