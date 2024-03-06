#!/bin/bash

set -eu
set -x

#DIR=$(realpath $(dirname $0)/..)
#source ${DIR}/lib.sh

INV=/CONF/tmp-inventory.yaml

TARGET="$1"
shift

# ex. --extra-vars gfarm_install=yes
EXTRA=

ANSIBLE_CONFIG=/CONF/ansible.cfg
export ANSIBLE_CONFIG

ansible-playbook $EXTRA -i $INV /CONF/playbook-gfarm.yaml -vv "$@"
