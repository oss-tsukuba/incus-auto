#!/bin/bash

set -eu
set -x

source /SCRIPT/lib.sh

# for gfarm-manage container

TARGET="$1"
shift

LIMIT=$(ANSIBLE_LIMIT "$TARGET")

while ! ansible-playbook -i $INV $LIMIT /CONF/playbook-ready.yaml -vv "$@" > /dev/null 2>&1; do
    echo -n .
    sleep 1
done
echo
