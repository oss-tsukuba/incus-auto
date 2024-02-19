#!/bin/bash

set -eu
set -x

source /SCRIPT/lib.sh

TARGET="$1"
shift

# ex. --extra-vars gfarm_install=yes
EXTRA=

LIMIT=$(ANSIBLE_LIMIT "$TARGET")

ansible-playbook $EXTRA -i $INV $LIMIT /CONF/playbook-gfarm.yaml -vv "$@"
