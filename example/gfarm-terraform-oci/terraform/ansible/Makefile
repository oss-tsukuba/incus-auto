help:
	@awk -F ':' '/^[^#[:space:]].*:/ {print $1}' Makefile | sed 's/://'

ansible-init:
	@bash ./confirm.sh
	sudo cloud-init status --wait
	bash ./ansible-init.sh
	bash ./ansible-cloud-init-wait.sh
ansible-ping:
	bash ./ansible-ping.sh
ansible-disable-selinux:
	bash ./ansible-disable-selinux.sh
ansible-dnf-update:
	bash ./ansible-dnf-update.sh
ansible-reboot:
	@bash ./confirm.sh
	bash ./ansible-cloud-init-wait.sh
	bash ./ansible-reboot.sh
ansible-gfarm-install:
	bash ./ansible-gfarm-install.sh
ansible-gfarm-setup:
	bash ./ansible-gfarm-setup.sh
ansible-gfarm-restart:
	bash ./ansible-gfarm-restart.sh

gfarm-config-init:
	ln -fs ~/gfarm-setup-tmp/.gfarm_shared_key-gfarmsys ~/.gfarm_shared_key
	ln -fs ~/gfarm-setup-tmp/dot_globus/gfarmsys ~/.globus
	sudo ln -fs ~/gfarm-setup-tmp/gfarm2.conf /usr/local/etc/gfarm2.conf
gfarm-regress:
	bash ./gfarm-regress.sh

ansible-gfarm-DESTROY:
	@bash ./confirm.sh
	bash ./ansible-gfarm-unconfig.sh
