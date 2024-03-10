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
ansible-gfarm-regress:
	bash ./ansible-gfarm-regress.sh

gfarm-config-init:
	ln -fs ~/gfarm-setup-tmp/.gfarm_shared_key-gfarmsys ~/.gfarm_shared_key
	ln -fs ~/gfarm-setup-tmp/gfarm2.conf ~/.gfarm2rc
	ln -fs ~/gfarm-setup-tmp/dot_globus/gfarmsys ~/.globus

ansible-gfarm-DESTROY:
	@bash ./confirm.sh
	bash ./ansible-gfarm-unconfig.sh
