#!/bin/bash

source ./ansible-common.sh
ansible-playbook -i $INV ./playbook-gfarm-restart.yaml "$@"
