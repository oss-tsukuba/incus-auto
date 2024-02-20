#!/bin/bash

# for manage host to use ansible

source /SCRIPT/lib.sh

APTGET update
APTGET install -y \
	emacs-nox \
	vim

SUDO mkdir -p "$SSHDIR"
SUDO chmod 700 "$SSHDIR"
SUDO touch "${SSHDIR}/known_hosts"
SUDO chmod 600 "${SSHDIR}/known_hosts"
SUDO chown $SYS_USER:$SYS_USER "${SSHDIR}/known_hosts"
SUDO cp "$SSH_PRIVKEY_SRC" "$SSH_PRIVKEY_DST"
SUDO chmod 600 "$SSH_PRIVKEY_DST"
SUDO chown $SYS_USER:$SYS_USER "$SSH_PRIVKEY_DST"

SUDO cp "$SSH_CONFIG_SRC" "$SSH_CONFIG_DST"
SUDO chmod 600 "$SSH_CONFIG_DST"
SUDO chown $SYS_USER:$SYS_USER "$SSH_CONFIG_DST"
