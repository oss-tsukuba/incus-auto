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

DOWN:
	$(IA) stop -a
	$(IA) delete -a
CLEAN: DOWN
	$(IA) destroy
#TODO REBUILD-ALL:
# 	make CLEAN
# 	make incus-init
# 	make incus-create
