#!/bin/bash

source ./ansible-common.sh
ansible-playbook -i $INV ./playbook-ssh-keyscan.yaml
ansible-playbook -i $INV ./playbook-ssh-send-privkey.yaml
