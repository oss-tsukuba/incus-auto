#!/bin/bash

source ./ansible-common.sh
PATT="gfmd:gfsd:gfclient"
ansible -i $INV -m raw -b -a 'dnf update -y' $PATT
