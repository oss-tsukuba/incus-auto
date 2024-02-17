#!/bin/bash

source /SCRIPT/lib.sh

ansible -i $INV gfarm -a "bash /SCRIPT/install-gfarm.sh --reinstall"
