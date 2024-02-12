# aws-infrastructure-example

## Overview

This repository serves as an example of using Terragrunt to deploy Terraform modules across an AWS Organization configured with Identity Center. 

## Features

- **DRY Configuration**: Utilizes Terragrunt to minimize repetition across configurations, enhancing maintainability.
- **Dynamic Tagging**: Automatically tags resources based on their deployment path and environment, improving resource management and cost tracking.
- **Module Versioning**: Supports specifying versions for Terraform modules, ensuring consistent deployments across environments.
- **Dependency Management**: Allows for declaring dependencies between resources, ensuring correct deployment order and terraform output inheritance.
- **CI/CD Integration**: Can be used in CICD to deploy ephemeral PR environments without having to make git commits.