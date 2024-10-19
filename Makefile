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

.PHONY: docker-init
docker-init:
	docker run --rm -v ${PWD}/terraform:/workspace -w /workspace hashicorp/terraform:latest init

.PHONY: docker-plan
docker-plan:
	docker run --rm -v ${PWD}/terraform:/workspace -v ~/.ssh:/root/.ssh -w /workspace hashicorp/terraform:latest plan

.PHONY: docker-apply
docker-apply:
	docker run --rm -v ${PWD}/terraform:/workspace -v ~/.ssh:/root/.ssh -w /workspace hashicorp/terraform:latest apply -auto-approve

.PHONY: docker-destroy
docker-destroy:
	docker run --rm -v ${PWD}/terraform:/workspace -v ~/.ssh:/root/.ssh -w /workspace hashicorp/terraform:latest destroy -auto-approve