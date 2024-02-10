IA = incus-auto

manage:
	$(IA) shell manage
client:
	$(IA) shell gfclient1
init:
	$(IA) init
build:
	$(IA) build -a
create:
	./RECREATE.sh ALL
setup:
	make update-etchosts
	$(IA) exec manage -- bash /SCRIPT/setup-gfarm-by-ansible.sh
clear: #TODO
	$(IA) exec manage -- bash /SCRIPT/clear-gfarm-by-ansible.sh
reinstall-gfarm:
	$(IA) exec manage -- bash /SCRIPT/reinstall-gfarm-by-ansible.sh
recreate-lustre:
	# TODO incus-auto delete -f
	incus delete -f gfarm-mgs || true
	incus delete -f gfarm-oss0 || true
	incus delete -f gfarm-oss1 || true
	incus delete -f gfarm-lclient1 || true
	# TODO incus-auto delete-block
	# incus storage volume delete mypool gfarm-lustre-mdt || true
	# incus storage volume delete mypool gfarm-lustre-oss0 || true
	# incus storage volume delete mypool gfarm-lustre-oss1 || true
	./RECREATE.sh mgs
	./RECREATE.sh oss0
	./RECREATE.sh oss1
	./RECREATE.sh lclient1
	make update-etchosts
update-etchosts:
	$(IA) update-etchosts -a
	$(IA) exec manage -- bash -x /SCRIPT/setup-ansible.sh
down:
	$(IA) stop -a
	$(IA) delete -a
