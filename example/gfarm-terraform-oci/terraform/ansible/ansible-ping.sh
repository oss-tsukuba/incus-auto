#!/bin/bash

source ./ansible-common.sh
ansible -i $INV all -m ping
