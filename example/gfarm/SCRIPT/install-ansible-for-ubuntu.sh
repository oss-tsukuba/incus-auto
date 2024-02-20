#!/bin/sh

source /SCRIPT/lib.sh

APTGET update
APTGET install -y software-properties-common
SUDO add-apt-repository -y --update ppa:ansible/ansible
APTGET install -y ansible

echo DONE "$0"
