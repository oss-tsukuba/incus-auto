IA = incus-auto

shell:
	$(IA) shell gfclient1
manage:
	$(IA) shell manage
init:
	./RECREATE.sh ALL
setup-gfarm:
	$(IA) exec manage -- ansible-playbook -i /CONF/inventories.yaml /CONF/playbook-gfarm.yaml -vvv
down:
	$(IA) stop -a
	$(IA) delete -a
