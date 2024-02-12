# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "FOOAccount"
  aws_account_id = "123456789012"
  application    = "foo"
}
