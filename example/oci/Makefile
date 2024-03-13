IA = ../../bin/incus-auto
TFEXEC = $(IA) exec tf --
TFBASH = $(TFEXEC) bash

shell:
	$(IA) shell tf
ps:
	$(IA) ps
incus-init:
	$(IA) init
# build:
# 	$(IA) build -a
incus-create:
	$(IA) launch -a


#TODO api-keygen:
#	bash SCRIPT/setup-oci-api.sh
ssh-keygen:
	ssh-keygen -t ecdsa -f terraform/id_ecdsa

#TODO sync-ansible:

#TODO
# ssh-manage:
# 	$(IA) exec tf -- bash /SCRIPT/ocissh manage.example.org
# ansible-init:
# 	$(IA) exec tf -- bash /SCRIPT/setup-ansible.sh
# ansible-ping:
# 	$(IA) exec tf -- bash /SCRIPT/ansible-ping.sh

DOWN:
	$(IA) stop -a
	$(IA) delete -a
CLEAN: DOWN
	$(IA) destroy
REBUILD-ALL:
	make CLEAN
	make incus-init
	make incus-create
