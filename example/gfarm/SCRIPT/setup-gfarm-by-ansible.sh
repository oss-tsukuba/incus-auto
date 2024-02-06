#!/bin/sh

cd /CONF
# ex. --extra-vars gfarm_install=no
ansible-playbook -i inventories.yaml playbook-gfarm.yaml -vv "$@"
