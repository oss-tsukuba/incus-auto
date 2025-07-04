DEBUG = -l debug
IA = ../../bin/incus-auto
IAGF = $(IA) -c $(shell ./CONFIG.sh gfarm)
IALS = $(IA) -c $(shell ./CONFIG.sh lustre)
IAALL= $(IA) -c $(shell ./CONFIG.sh all)
CMD = $(shell $(IALS) config | grep incus_command | awk '{print $$2}')
POOL = $(shell $(IALS) config | grep default_pool | awk '{print $$2}')
FSNAME = testfs
MDTNAME = mdt.$(FSNAME)-MDT0000
INV = CACHE/tmp-inventory.yaml  # SEE ALSO: SCRIPT/lib.sh

gfmanage:
	$(IAGF) shell gfmanage
gfclient:
	$(IAGF) shell gfclient01
lclient:
	$(IALS) shell lclient1

flake8:
	flake8 $(IA)

git-clone:
	./git-clone-pull.sh
git-pull:
	./git-clone-pull.sh pull

ps:
	@$(IAALL) ps
image:
	@$(IAALL) ps -b
show-config-all:
	$(IAALL) config
update-dnsmasq:
	$(IAALL) update-dnsmasq
print-etchosts:
	@$(IAALL) print-etchosts
update-etchosts-all:
	$(IAALL) update-etchosts -a
gen-inventory:
	$(IAALL) ansible-inventory > $(INV)
ansible-init:
	make gen-inventory
	$(IAALL) exec gfmanage -- bash -x /SCRIPT/setup-ansible.sh

stop:
	$(IAALL) -ab stop
	$(IAALL) -a stop
start:
	# $(IALS) -a start
	# $(IAGF) -a start
	$(IAALL) -a start
	$(IAALL) wait -a
	make ps

init:
	$(IAGF) init

show-config-gfarm:
	$(IAGF) config
build-gfarm:
	$(IAGF) build -a $(DEBUG)
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
	$(IAGF) exec gfclient01 -- bash /SCRIPT/setup-gfperf.sh
delete-gfarm:
	$(IAGF) stop -a -f
	$(IAGF) delete -a

send-ssh-privkey:
	$(IAGF) exec gfmanage -- bash /SCRIPT/ansible-send-ssh-privkey.sh
regress:
	$(IAGF) exec gfclient01 -- bash /SCRIPT/gfarm-regress.sh

show-config-lustre:
	$(IALS) config
build-lustre:
	$(IALS) build -a $(DEBUG)
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
	$(CMD) storage volume delete $(POOL) gfarm-lustre-mdt || true
	$(CMD) storage volume delete $(POOL) gfarm-lustre-oss0 || true
	$(CMD) storage volume delete $(POOL) gfarm-lustre-oss1 || true
start-lustre-hsm:
	$(IALS) exec mgs --root -- lctl set_param $(MDTNAME).hsm_control=enabled
	$(IALS) exec mgs --root -- lctl get_param $(MDTNAME).hsm_control
	$(IALS) exec lclient1 --root -- bash /SCRIPT/hsm-start.sh

setup-gfarm-all:
	$(IAALL) wait -a
	make update-dnsmasq
	make ansible-init
	$(IAGF) exec gfmanage -- bash /SCRIPT/get-ready.sh all
	$(IAGF) exec gfmanage -- bash /SCRIPT/setup-gfarm-by-ansible.sh all

gfhost:
	$(IAALL) exec gfclient01 -- gfhost -lv
	$(IAALL) exec lclient1 -- gfhost -lv

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
	#make setup-gfperf

REBUILD-ALL:
	make CLEAN
	make show-config-all
	make init
	make build-gfarm
	make launch-gfarm
	make build-lustre
	make launch-lustre
	make setup-gfarm-all
	#make setup-gfperf
	make ps
	make gfhost

REBUILD-PARA-ALL:
	./build-para.sh
	#make setup-gfperf
	make ps
	make gfhost
