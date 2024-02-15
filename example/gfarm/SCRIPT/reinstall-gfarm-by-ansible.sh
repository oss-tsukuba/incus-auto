#!/bin/sh

cd /CONF
ansible -i inventories.yaml gfarm -a "bash /SCRIPT/install-gfarm.sh --reinstall"
