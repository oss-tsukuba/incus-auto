IA = ../../bin/incus-auto
TFEXEC = $(IA) exec tf --
TFBASH = $(TFEXEC) bash

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
	docker compose build

docker-up:
	docker compose up -d
	docker compose exec -u ${USER} tf sudo ln -sf /TF /home/${USER}/terraform

docker-shell:
	docker compose exec -it -u ${USER} -w /home/${USER} tf bash

docker-down:
	docker compose down
