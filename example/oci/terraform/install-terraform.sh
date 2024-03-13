#!/bin/bash

set -eu
set -x

sudo apt-get install -y make jq bash-completion
sudo apt-get install -y gnupg

KEYRING=$HOME/hashicorp-archive-keyring.gpg
wget -O- https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor > $KEYRING

FP="798A EC65 4E5C 1542 8C8E  42EE AA16 FCBC A621 E701"
#gpg --no-default-keyring --keyring ${KEYRING} --fingerprint | grep "$FP"
gpg --no-default-keyring --keyring ${KEYRING} --fingerprint | grep "798A"

sudo cp -f $KEYRING /usr/share/keyrings/

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update
sudo apt-get install -y terraform
terraform -install-autocomplete
