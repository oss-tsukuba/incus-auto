#!/bin/bash

source /SCRIPT/lib.sh

# for gfarm-manage container

# add ~/.ssh/known_hosts
$CMD_PLAYBOOK -i $INV /CONF/ssh-keyscan.yaml

#$CMD_ANSIBLE -i $INV all -m ping
#$CMD_ANSIBLE -i $INV all -a hostname
