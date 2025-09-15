#!/bin/sh

set -eu
set -x

install_docekr_for_centos() {
    # https://docs.docker.com/engine/install/centos/

    sudo yum remove -y docker \
	 docker-client \
	 docker-client-latest \
	 docker-common \
	 docker-latest \
	 docker-latest-logrotate \
	 docker-logrotate \
	 docker-engine

    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # for Gfarm developer
    sudo yum install -y rsync make bash-completion less git
}

install_docekr_for_ubuntu() {
    # https://docs.docker.com/engine/install/ubuntu/

    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # for Gfarm developer
    sudo apt-get install -y rsync make bash-completion less git
}

. /etc/os-release

case $ID in
    rocky|almalinux)
	install_docekr_for_centos
	;;
    ubuntu)
	install_docekr_for_ubuntu
	;;
    *)
	echo "not supported"
	exit 1
	;;
esac

sudo systemctl enable docker
sudo systemctl restart docker

sudo usermod -a -G docker gfarmsys
