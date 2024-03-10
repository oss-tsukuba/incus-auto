INV = tmp-ansible-inventory.yaml

all:
	@true

ansible-init:
	@bash ./confirm.sh
	bash ./ansible-init.sh
ansible-ping:
	bash ./ansible-ping.sh
ansible-gfarm-install:
	bash ./ansible-gfarm-install.sh
ansible-gfarm-setup:
	bash ./ansible-gfarm-setup.sh
ansible-gfarm-DESTROY:
	@bash ./confirm.sh
	bash ./ansible-gfarm-unconfig.sh
