IA = incus-auto

shell:
	$(IA) shell gfclient1
manage:
	$(IA) shell manage
init:
	./RECREATE.sh ALL
setup-gfarm:
	$(IA) exec manage -- bash /SCRIPT/setup-gfarm-by-ansible.sh
clear-gfarm: #TODO
	$(IA) exec manage -- bash /SCRIPT/clear-gfarm-by-ansible.sh
down:
	$(IA) stop -a
	$(IA) delete -a
