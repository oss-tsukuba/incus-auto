#!/bin/sh

cd /CONF
ansible-playbook -i inventories.yaml playbook-gfarm.yaml -vvv
