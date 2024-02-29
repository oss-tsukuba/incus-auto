#!/bin/bash

INV=/CONF/tmp-inventory.yaml

sudo apt-get update
sudo sudo apt-getinstall -y software-properties-common
sudo add-apt-repository -y --update ppa:ansible/ansible
sudo apt-get install -y ansible

bash /SCRIPT/ansible-inventory.sh > $INV

ansible-playbook -i $INV /CONF/ssh-keyscan.yaml
