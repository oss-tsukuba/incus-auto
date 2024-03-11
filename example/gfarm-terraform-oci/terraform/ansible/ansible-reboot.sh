#!/bin/bash

source ./ansible-common.sh
PATT="gfmd:gfsd:gfclient"
ansible -i $INV -b -m ansible.builtin.reboot $PATT
