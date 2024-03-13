RSYNC = rsync -e ./ocissh -av

ssh-gfmanage:
	./ocissh gfmanage

ociapi-keygen:
	bash ./setup-oci-api.sh
terraform-init:
	terraform init
terraform-plan:
	terraform plan
terraform-apply:
	terraform apply
terraform-destroy:
	terraform destroy -target oci_dns_rrset.gfarm_dns_record
	terraform destroy

print-etchosts:
	@bash ./print-etchosts.sh
print-ssh_config:
	@bash ./print-sshconfig.sh
print-ansible-inventory:
	@bash ./print-ansible-inventory.sh

update-ssh_known_hosts:
	@bash ./ansible/confirm.sh
	bash ./print-ssh-keyscan.sh > ./tmp-ssh_known_hosts
update-ssh_config:
	bash ./print-sshconfig.sh > ./tmp-ssh_config
update-ansible-inventory:
	bash ./print-ansible-inventory.sh > ./ansible/tmp-ansible-inventory.yaml
update-all:
	make update-ssh_known_hosts
	make update-ssh_config
	make update-ansible-inventory

gfarm-install:
	@bash ./ansible/confirm.sh
	bash ./ansible/SRC/install-gfarm.sh
gfarm-config-fetch:
	@bash ./ansible/confirm.sh
	$(RSYNC) gfmanage:gfarm-setup-tmp/.gfarm_shared_key-gfarmsys ~/.gfarm_shared_key
	$(RSYNC) gfmanage:gfarm-setup-tmp/gfarm2.conf ~/.gfarm2rc
	$(RSYNC) gfmanage:gfarm-setup-tmp/dot_globus/gfarmsys/ ~/.globus/
	$(RSYNC) gfmanage:/etc/grid-security/certificates/ ~/.globus/certificates/
	grep -r ^tls_ca_certificate_path ~/.gfarm2rc || echo "tls_ca_certificate_path /home/gfarmsys/.globus/certificates/" >> ~/.gfarm2rc
update-etchosts-for-gfarm:
	@bash ./ansible/confirm.sh
	bash ./update-etchosts.sh

send-files:
	$(RSYNC) ./ gfmanage:terraform/
SYNC-files-with-delete:
	$(RSYNC) --delete ./ gfmanage:terraform/
