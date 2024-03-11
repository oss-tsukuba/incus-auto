#!/bin/bash

source ./ansible-common.sh
ansible-playbook -i $INV ./playbook-disable-selinux.yaml "$@"
