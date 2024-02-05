#!/bin/sh

source /SCRIPT/lib.sh

SUDO apt-get update

SUDO apt-get install -y software-properties-common
SUDO add-apt-repository -y --update ppa:ansible/ansible

SUDO apt-get install -y ansible
