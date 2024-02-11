IA = incus-auto

manage:
	$(IA) shell tf
init:
	$(IA) init
build:
	$(IA) build -a
create:
	$(IA) launch -a
# setup:
# 	make update-etchosts
# 	$(IA) exec manage -- bash /SCRIPT/setup-gfarm-by-ansible.sh
# reset-gfarm: #TODO
# 	$(IA) exec manage -- bash /SCRIPT/reset-gfarm-by-ansible.sh
# reinstall-gfarm:
# 	$(IA) exec manage -- bash /SCRIPT/reinstall-gfarm-by-ansible.sh
# update-etchosts:
# 	$(IA) update-etchosts -a
# 	$(IA) exec manage -- bash -x /SCRIPT/setup-ansible.sh
down:
	$(IA) stop -a
	$(IA) delete -a
CLEAN: down
	$(IA) destroy
REBUILD-ALL:
	make CLEAN
	make init
	make build
	make create
	make setup
