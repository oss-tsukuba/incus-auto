#!/bin/bash

source /SCRIPT/lib.sh

$CMD_ANSIBLE -i $INV gfarm -a "bash /SCRIPT/install-gfarm.sh --reinstall"
