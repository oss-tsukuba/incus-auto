#!/bin/bash

source ./ansible-common.sh
PATT="gfmd:gfsd:gfclient"
ansible -i $INV -b -m command -a 'cloud-init status -w' $PATT
ansible -i $INV -b -m ansible.builtin.reboot $PATT
