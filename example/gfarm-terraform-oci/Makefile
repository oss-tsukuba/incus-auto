IA = ../../bin/incus-auto
TFEXEC = $(IA) exec tf --
TFBASH = $(TFEXEC) bash

shell:
	$(IA) shell tf
ps:
	$(IA) ps
ssh-keygen:
	ssh-keygen -t ecdsa -f terraform/id_ecdsa -N ""
incus-init:
	$(IA) init
incus-create:
	$(IA) launch -a



print-etchosts:
	@$(TFBASH) /SCRIPT/print-etchosts.sh
print-sshconfig:
	@$(TFBASH) /SCRIPT/print-sshconfig.sh
print-ansible-inventory:
	@$(TFBASH) /SCRIPT/print-ansible-inventory.sh

sshkeyscan-update:
	$(TFBASH) /SCRIPT/print-ssh-keyscan.sh > CONF/tmp-known_hosts
sshconfig-update:
	$(TFBASH) /SCRIPT/print-sshconfig.sh > CONF/tmp-ssh_config

#TODO terraform-init:
#	$(IA) exec tf -- bash /SCRIPT/terraform.sh init --upgrade

#TODO sync-ansible:

#TODO
# ssh-manage:
# 	$(IA) exec tf -- bash /SCRIPT/ocissh manage.example.org
# ansible-init:
# 	$(IA) exec tf -- bash /SCRIPT/setup-ansible.sh
# ansible-ping:
# 	$(IA) exec tf -- bash /SCRIPT/ansible-ping.sh

#setup:
#	$(IA) exec tf -- bash /SCRIPT/setup-gfarm-by-ansible.sh
# reset-gfarm: #TODO
# 	$(IA) exec manage -- bash /SCRIPT/reset-gfarm-by-ansible.sh
# reinstall-gfarm:
# 	$(IA) exec manage -- bash /SCRIPT/reinstall-gfarm-by-ansible.sh
# update-etchosts:
# 	$(IA) update-etchosts -a
# 	$(IA) exec manage -- bash -x /SCRIPT/setup-ansible.sh

DOWN:
	$(IA) stop -a
	$(IA) delete -a
CLEAN: DOWN
	$(IA) destroy
#TODO REBUILD-ALL:
# 	make CLEAN
# 	make incus-init
# 	make incus-create
