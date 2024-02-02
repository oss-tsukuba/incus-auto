#!/bin/sh

source /SCRIPT/lib.sh

# for gfarm-manage-*

# TODO incus-auto.yaml から、ansible-inventory -i /CONF/inventories.yaml --list 相当形式を出力する。

# add ~/.ssh/known_hosts
INV=/CONF/inventories.yaml
ansible-playbook -i $INV /CONF/ssh-keyscan.yaml

ansible -i $INV all -m ping
ansible -i $INV all -a hostname
