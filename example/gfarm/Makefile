IA = incus-auto

manage:
	$(IA) shell manage
client:
	$(IA) shell gfclient1
init:
	$(IA) init
build:
	$(IA) build -a
recreate:
	./RECREATE.sh ALL
setup:
	$(IA) exec manage -- bash /SCRIPT/setup-gfarm-by-ansible.sh
clear: #TODO
	$(IA) exec manage -- bash /SCRIPT/clear-gfarm-by-ansible.sh
delete-lustre-volume:
	incus delete -f gfarm-mgs
	incus storage volume delete mypool lustre-mdt
down:
	$(IA) stop -a
	$(IA) delete -a
