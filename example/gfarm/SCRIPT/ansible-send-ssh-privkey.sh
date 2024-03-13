#!/bin/bash

set -eu
set -x

source /SCRIPT/lib.sh

ANSIBLE_CONFIG=/CONF/ansible.cfg
export ANSIBLE_CONFIG

ansible-playbook -i $INV /CONF/playbook-ssh-send-privkey.yaml
