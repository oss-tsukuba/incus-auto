#!/bin/bash

source ./ansible-common.sh
ansible-playbook -i $INV -t "install" ./playbook-gfarm.yaml "$@"
