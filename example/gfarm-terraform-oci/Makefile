IA = ../../bin/incus-auto
TFEXEC = $(IA) exec tf --
TFBASH = $(TFEXEC) bash
DOCKER_CMD = docker

shell:
	$(IA) shell tf
ps:
	$(IA) ps

git-clone:
	./terraform/ansible/git-clone-pull.sh
git-pull:
	./terraform/ansible/git-clone-pull.sh pull

ociapi-keygen:
	bash ./terraform/setup-oci-api.sh
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

#REBUILD-ALL:
# 	make CLEAN
# 	make incus-init
# 	make incus-create

docker-build:
	$(DOCKER_CMD) compose build

docker-up:
	$(DOCKER_CMD) compose up -d
	$(DOCKER_CMD) compose exec -u ${USER} tf sudo ln -sf /TF /home/${USER}/terraform

docker-shell:
	$(DOCKER_CMD) compose exec -it -u ${USER} -w /home/${USER} tf bash

docker-down:
	$(DOCKER_CMD) compose down
