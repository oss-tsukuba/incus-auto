#!/bin/bash

source ./ansible-common.sh

#sudo apt-get install -y software-properties-common
#sudo add-apt-repository -y --update ppa:ansible/ansible
#sudo apt-get install -y ansible

pipx install ansible --include-deps

ansible-playbook -i $INV ./playbook-ssh-keyscan.yaml
ansible-playbook -i $INV ./playbook-ssh-send-privkey.yaml
