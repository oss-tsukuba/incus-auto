ociapi-keygen:
	bash setup-oci-api.sh
terraform-init:
	terraform init
terraform-plan:
	terraform plan
terraform-apply:
	terraform apply

print-etchosts:
	@bash ./print-etchosts.sh
print-ssh_config:
	@bash ./print-sshconfig.sh
print-ansible-inventory:
	@bash ./print-ansible-inventory.sh

update-ssh_known_hosts:
	bash ./print-ssh-keyscan.sh > ./tmp-ssh_known_hosts
update-ssh_config:
	bash ./print-sshconfig.sh > ./tmp-ssh_config
update-ansible-inventory:
	bash ./print-ansible-inventory.sh > ./ansible/tmp-ansible-inventory.yaml
update-all:
	make update-ssh_known_hosts
	make update-ssh_config
	make update-ansible-inventory

send-files:
	rsync -e ./ocissh -av ./ gfmanage:terraform-oci/

ssh-gfmanage:
	./ocissh manage
