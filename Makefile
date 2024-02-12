# make envcommon MODULES="aws-vpc aws-alb"
# make infra MODULE=aws-identity-center-permission-set DEST_PATH=management/identity-center/permission-sets/
# make infra MODULE=aws-service-control-policies DEST_PATH=management/organization/policies/
# make infra MODULE=aws-ecs-service DEST_PATH=workloads/foo/dev/us-west-2/alb

GITHUB_ORG ?= GithubOrg
DEST_PATH ?= default_path
MODULES ?= default_module
SHELL := /bin/bash

.PHONY: envcommon
envcommon:
	$(eval MODULES := $(subst ',', ,$(MODULE)))
	@for module in $(MODULES); do \
		cp templates/envcommon.hcl _envcommon/$$module.hcl; \
		sed -i '' 's/template/'$$module'/g' _envcommon/$$module.hcl; \
		sed -i '' 's/github_org/$(GITHUB_ORG)/g' _envcommon/$$module.hcl; \
	done

.PHONY: infra
infra:
	mkdir -p $(DEST_PATH)
	cp templates/infrastructure.hcl $(DEST_PATH)/terragrunt.hcl
	sed -i '' 's/template/$(MODULE)/g' $(DEST_PATH)/terragrunt.hcl
	$(eval MODULE_CAPS := $(shell echo $(MODULE) | tr '-' ' ' | tr '[:lower:]' '[:upper:]'))
	sed -i '' 's/TEMPLATE/$(MODULE_CAPS)/g' $(DEST_PATH)/terragrunt.hcl
	$(eval FIRST_PATH_SEGMENT := $(shell echo $(DEST_PATH) | cut -d '/' -f1))
	sed -i '' 's/source/$(FIRST_PATH_SEGMENT)/g' $(DEST_PATH)/terragrunt.hcl