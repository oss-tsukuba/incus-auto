#!/bin/bash

set -eu
set -x

source /SCRIPT/lib.sh

$CMD_PLAYBOOK -i $INV /CONF/playbook-ssh-send-privkey.yaml
