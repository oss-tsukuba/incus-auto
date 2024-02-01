#!/bin/sh

# for manage host to use ansible

source /SCRIPT/lib.sh

apt-get update
apt-get install -y \
	emacs-nox \
	vim

mkdir -p "$SSHDIR"
chmod 700 "$SSHDIR"
touch "${SSHDIR}/known_hosts"
chmod 600 "${SSHDIR}/known_hosts"
chown $ANSIBLE_USER:$ANSIBLE_USER "${SSHDIR}/known_hosts"
cp "$SSH_PRIVKEY_SRC" "$SSH_PRIVKEY_DST"
chmod 600 "$SSH_PRIVKEY_DST"
chown $ANSIBLE_USER:$ANSIBLE_USER "$SSH_PRIVKEY_DST"
