#!/bin/bash

# for manage host to use ansible

source /SCRIPT/lib.sh

SUDO apt-get update
SUDO apt-get install -y \
	emacs-nox \
	vim

SUDO mkdir -p "$SSHDIR"
SUDO chmod 700 "$SSHDIR"
SUDO touch "${SSHDIR}/known_hosts"
SUDO chmod 600 "${SSHDIR}/known_hosts"
SUDO chown $ANSIBLE_USER:$ANSIBLE_USER "${SSHDIR}/known_hosts"
SUDO cp "$SSH_PRIVKEY_SRC" "$SSH_PRIVKEY_DST"
SUDO chmod 600 "$SSH_PRIVKEY_DST"
SUDO chown $ANSIBLE_USER:$ANSIBLE_USER "$SSH_PRIVKEY_DST"
