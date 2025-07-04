#!/bin/sh

source /SCRIPT/lib.sh

### https://docs.ansible.com/ansible/2.9_ja/installation_guide/intro_installation.html#ubuntu-ansible
### NOTE: Ansible core 2.17 or later cannot work on RHEL8
# APTGET update
# APTGET install -y software-properties-common
# SUDO add-apt-repository -y --update ppa:ansible/ansible
# APTGET install -y ansible


### https://docs.ansible.com/ansible/2.9_ja/installation_guide/intro_installation.html#pip-ansible
# Install ansible 2.16
APTGET update
APTGET install -y python3-pip
pip install --user "ansible-core<2.17"
CMD_GALAXY=~/.local/bin/ansible-galaxy
$CMD_GALAXY collection install community.general
$CMD_GALAXY collection install ansible.posix

echo DONE "$0"
