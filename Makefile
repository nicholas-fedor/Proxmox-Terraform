.PHONY: all
all:  init validate plan apply

.PHONY: init
init:
	cd terraform && \
	terraform init

.PHONY: validate
validate:
	cd terraform && \
	terraform validate

.PHONY: plan
plan:
	cd terraform && \
	terraform plan

.PHONY: apply
apply:
	cd terraform && \
	terraform apply

.PHONY: destroy
destroy:
	cd terraform && \
	terraform destroy

.PHONY: new
new:
	cd terraform && \
	terraform workspace new $(workspace)

.PHONY: delete
delete:
	cd terraform && \
	terraform workspace select default && \
	terraform workspace delete $(workspace)