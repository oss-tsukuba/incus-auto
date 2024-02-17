IA = ../../bin/incus-auto
IAGF = $(IA) -c $(shell ./CONFIG.sh gfarm)
IALS = $(IA) -c $(shell ./CONFIG.sh lustre)
IAALL= $(IA) -c $(shell ./CONFIG.sh all)
POOL = mypool
FSNAME = testfs
MDTNAME = mdt.$(FSNAME)-MDT0000

manage:
	$(IAGF) shell manage
gfclient:
	$(IAGF) shell gfclient1
lclient:
	$(IALS) shell lclient1

ps:
	@$(IAALL) ps
image:
	@$(IAALL) ps -b
show-config-all:
	$(IAALL) config
update-etchosts:
	$(IAALL) update-etchosts -a
ansible-init:
	$(IAALL) exec manage -- bash -x /SCRIPT/setup-ansible.sh

init:
	$(IAGF) init

show-config-gfarm:
	$(IAGF) config
build-gfarm:
	$(IAGF) build -a
launch-gfarm:
	$(IAGF) launch -a
	$(IAGF) update-etchosts -a
setup-gfarm:
	make ansible-init
	$(IAGF) exec manage -- bash /SCRIPT/setup-gfarm-by-ansible.sh gfarm
reinstall-gfarm:
	$(IAGF) exec manage -- bash /SCRIPT/reinstall-gfarm-by-ansible.sh
#TODO reset-gfarm:
# 	$(IAGF) exec manage -- bash /SCRIPT/reset-gfarm-by-ansible.sh
setup-gfperf:
	$(IAGF) exec gfclient1 -- bash /SCRIPT/setup-gfperf.sh
delete-gfarm:
	$(IAGF) stop -a
	#TODO $(IAGF) delete -a -f
	$(IAGF) delete -a

show-config-lustre:
	$(IALS) config
build-lustre:
	$(IALS) build -a
launch-lustre:
	$(IALS) launch -a
	$(IAALL) update-etchosts -a
delete-lustre:
	# TODO incus-auto delete -f
	# incus delete -f gfarm-mgs || true
	# incus delete -f gfarm-oss0 || true
	# incus delete -f gfarm-oss1 || true
	# incus delete -f gfarm-lclient1 || true
	$(IALS) stop -a
	#TODO $(IAGF) delete -a -f
	$(IALS) delete -a
start-lustre-hsm:
	$(IALS) exec mgs --root -- lctl set_param $(MDTNAME).hsm_control=enabled
	$(IALS) exec mgs --root -- lctl get_param $(MDTNAME).hsm_control
	$(IALS) exec lclient1 -- bash /SCRIPT/hsm-start.sh

setup-gfarm-all:
	make ansible-init
	$(IAGF) exec manage -- bash /SCRIPT/setup-gfarm-by-ansible.sh all

down:
	$(IAALL) stop -a
	$(IAALL) delete -a
	incus storage volume delete $(POOL) gfarm-lustre-mdt || true
	incus storage volume delete $(POOL) gfarm-lustre-oss0 || true
	incus storage volume delete $(POOL) gfarm-lustre-oss1 || true
CLEAN: down
	$(IAALL) destroy
REBUILD-ALL:
	make CLEAN
	make show-config-all
	make init
	make build-gfarm
	make launch-gfarm
	make setup-gfperf
	make build-lustre
	make launch-lustre
	make setup-gfarm-all
