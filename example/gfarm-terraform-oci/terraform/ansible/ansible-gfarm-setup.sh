#!/bin/bash

source ./ansible-common.sh
ansible-playbook -e "gfarm_install=no" -i $INV ./playbook-gfarm.yaml "$@"
