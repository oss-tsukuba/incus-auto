#!/bin/bash

source ./ansible-common.sh
ansible-playbook -i $INV ./playbook-gfarm.yaml -f 10 -vv "$@"
