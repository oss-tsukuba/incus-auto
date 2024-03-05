#!/bin/sh

INV=/CONF/tmp-inventory.yaml

ANSIBLE_CONFIG=/CONF/ansible.cfg
export ANSIBLE_CONFIG

ansible -i $INV all -m ping
