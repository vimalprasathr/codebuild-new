SHELL=/bin/bash

TERRA_ENV=terraform
terra_env?=$(TERRA_ENV)

## clean: clean temporary files
.PHONY: clean
clean:
	find . -type d -name '.terraform' -delete

.PHONY: env
env:
	env

## init: runs init
.PHONY: init
init:
	terraform init -reconfigure -upgrade

## validate: runs validate
.PHONY: validate
validate:
	terraform validate

## fmt: reformat code
.PHONY: fmt
fmt:
	find . \( ! -regex '.*/\..*' \) -type d -exec terraform fmt {} \;

## check: checks the terraform code
.PHONY: check
check:
	find . \( ! -regex '.*/\..*' \) -type d -exec terraform fmt -check {} \;

## plan: runs init fmt and validate
.PHONY: plan
plan: init fmt validate
	terraform plan -var-file="${terra_env}.tfvars" -refresh=true

## raw-plan: runs terraform plan
.PHONY: raw-plan
raw-plan:
	terraform plan -var-file="${terra_env}.tfvars" -refresh=true

## apply: runs init fmt validate and apply
.PHONY: apply
apply: init fmt validate
	terraform apply -var-file="${terra_env}.tfvars" -auto-approve -lock=true -refresh=true

## raw-apply: runs terraform apply
.PHONY: raw-apply
raw-apply:
	terraform apply -var-file="${terra_env}.tfvars" -auto-approve -lock=true -refresh=true

## destroy: runs init fmt validate and destroy
.PHONY: destroy
destroy: init fmt validate
	terraform destroy -var-file="${terra_env}.tfvars" -auto-approve -lock=true -refresh=true

## raw-destroy: runs terraform destroy
.PHONY: raw-destroy
raw-destroy:
	terraform destroy -var-file="${terra_env}.tfvars" -auto-approve -lock=true -refresh=true

## refresh: runs terraform refresh
.PHONY: refresh
refresh:
	terraform refresh -var-file="${terra_env}.tfvars" -lock=true

## output: runs terraform output
.PHONY: output
output:
	terraform output

## pre-commit: run only pre-commit checkups
.PHONY: pre-commit
pre-commit:
	pre-commit run -a

## pre-commit-update: run pre-commit to fix formatting and generate terraform module documentation automaticaly from code
.PHONY: pre-commit-update
pre-commit-update:
	pre-commit install
	pre-commit autoupdate
	pre-commit run -a

## help: prints this help message
.PHONY: help
help:
	@echo "Usage:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
