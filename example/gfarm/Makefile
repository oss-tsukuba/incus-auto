DEBUG = -l debug
IA = ../../bin/incus-auto
IAGF = $(IA) -c $(shell ./CONFIG.sh gfarm)
IALS = $(IA) -c $(shell ./CONFIG.sh lustre)
IAALL= $(IA) -c $(shell ./CONFIG.sh all)
POOL = mypool
FSNAME = testfs
MDTNAME = mdt.$(FSNAME)-MDT0000
INV = CACHE/tmp-inventory.yaml  # SEE ALSO: SCRIPT/lib.sh

gfmanage:
	$(IAGF) shell gfmanage
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
update-etchosts-all:
	$(IAALL) update-etchosts -a
gen-inventory:
	$(IAALL) ansible-inventory > $(INV)
ansible-init:
	make gen-inventory
	$(IAALL) exec gfmanage -- bash -x /SCRIPT/setup-ansible.sh

init:
	$(IAGF) init

show-config-gfarm:
	$(IAGF) config
build-gfarm:
	$(IAGF) build -a
launch-gfarm:
	$(IAGF) launch -a $(DEBUG)
update-etchosts-gfarm:
	$(IAGF) update-etchosts -a
setup-gfarm:
	$(IAGF) wait -a
	make ansible-init
	$(IAGF) exec gfmanage -- bash /SCRIPT/get-ready.sh gfarm
	$(IAGF) exec gfmanage -- bash /SCRIPT/setup-gfarm-by-ansible.sh gfarm
reinstall-gfarm:
	$(IAGF) exec gfmanage -- bash /SCRIPT/reinstall-gfarm-by-ansible.sh
#TODO reset-gfarm:
# 	$(IAGF) exec gfmanage -- bash /SCRIPT/reset-gfarm-by-ansible.sh
setup-gfperf:
	$(IAGF) exec gfclient1 -- bash /SCRIPT/setup-gfperf.sh
delete-gfarm:
	$(IAGF) stop -a -f
	$(IAGF) delete -a

show-config-lustre:
	$(IALS) config
build-lustre:
	$(IALS) build -a
build-lustre-para:
	./build-lustre.sh build
launch-lustre:
	$(IALS) launch -a $(DEBUG)
launch-lustre-para:
	./build-lustre.sh launch
delete-lustre:
	$(IALS) stop -a -f
	$(IALS) delete -a
delete-lustre-block:
	incus storage volume delete $(POOL) gfarm-lustre-mdt || true
	incus storage volume delete $(POOL) gfarm-lustre-oss0 || true
	incus storage volume delete $(POOL) gfarm-lustre-oss1 || true
start-lustre-hsm:
	$(IALS) exec mgs --root -- lctl set_param $(MDTNAME).hsm_control=enabled
	$(IALS) exec mgs --root -- lctl get_param $(MDTNAME).hsm_control
	$(IALS) exec lclient1 -- bash /SCRIPT/hsm-start.sh

setup-gfarm-all:
	$(IAALL) wait -a
	make update-etchosts-all
	make ansible-init
	$(IAGF) exec gfmanage -- bash /SCRIPT/get-ready.sh all
	$(IAGF) exec gfmanage -- bash /SCRIPT/setup-gfarm-by-ansible.sh all

down:
	$(IAALL) stop -a -f
	$(IAALL) delete -a
	make delete-lustre-block
CLEAN: down
	$(IAALL) destroy

REBUILD-GFARM:
	make CLEAN
	make show-config-all
	make init
	make build-gfarm
	make launch-gfarm
	make setup-gfarm
	make setup-gfperf

REBUILD-ALL:
	make CLEAN
	make show-config-all
	make init
	make build-gfarm
	make launch-gfarm
	make build-lustre
	make launch-lustre
	make setup-gfarm-all
	make setup-gfperf

REBUILD-PARA-ALL:
	./build-para.sh
