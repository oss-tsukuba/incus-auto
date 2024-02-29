#!/bin/sh

ANSIBLE_CONFIG=/CONF/ansible.cfg
export ANSIBLE_CONFIG

ansible -i /CONF/tmp-inventory.yaml all -m ping
