#!/bin/bash

set -eu

INV=/CONF/tmp-inventory.yaml

sudo apt-get update
sudo apt-get install -y jq
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y --update ppa:ansible/ansible
sudo apt-get install -y ansible

bash /SCRIPT/print-ansible-inventory.sh > $INV

ansible-playbook -i $INV /CONF/ssh-keyscan.yaml
