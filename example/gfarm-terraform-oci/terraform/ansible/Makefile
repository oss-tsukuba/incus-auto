INV = tmp-ansible-inventory.yaml

help:
	@awk -F ':' '/^[^#[:space:]].*:/ {print $1}' Makefile | sed 's/://'

ansible-init:
	@bash ./confirm.sh
	bash ./ansible-init.sh
ansible-ping:
	bash ./ansible-ping.sh
ansible-gfarm-install:
	bash ./ansible-gfarm-install.sh
ansible-gfarm-setup:
	bash ./ansible-gfarm-setup.sh
ansible-gfarm-restart:
	bash ./ansible-gfarm-restart.sh
ansible-gfarm-DESTROY:
	@bash ./confirm.sh
	bash ./ansible-gfarm-unconfig.sh
