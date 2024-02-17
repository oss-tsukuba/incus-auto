#!/bin/bash

source /SCRIPT/lib.sh

# for gfarm-manage container

# add ~/.ssh/known_hosts
ansible-playbook -i $INV /CONF/ssh-keyscan.yaml

#ansible -i $INV all -m ping
#ansible -i $INV all -a hostname
