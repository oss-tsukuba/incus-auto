#!/bin/bash

set -eu
set -x

if type sudo; then
    SUDO=sudo
else
    SUDO=
fi

$SUDO apt-get update
$SUDO apt-get install -y gnupg bash-completion make jq rsync wget vim lsb-release bash-completion

KEYRING=${HOME}/hashicorp-archive-keyring.gpg
wget -O- https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor > $KEYRING

#FP="798A EC65 4E5C 1542 8C8E  42EE AA16 FCBC A621 E701"
#gpg --no-default-keyring --keyring ${KEYRING} --fingerprint | grep "$FP"
gpg --no-default-keyring --keyring ${KEYRING} --fingerprint | grep " 798A EC65 4E5C 1542 8C8E "

$SUDO cp -f ${KEYRING} /usr/share/keyrings/

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
$SUDO tee /etc/apt/sources.list.d/hashicorp.list

$SUDO apt-get update
$SUDO apt-get install -y terraform
terraform -install-autocomplete || true
