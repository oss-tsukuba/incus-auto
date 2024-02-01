set -eu

source /etc/os-release

CONF_DIR=/CONF
SCRIPT_DIR=/SCRIPT
SECRET_DIR=/INCUS-AUTO  # secret dir for management host

ANSIBLE_USER=gfadm  # incus-auto.yaml:/config/user
HOMEDIR="/home/${ANSIBLE_USER}"
SSHDIR="${HOMEDIR}/.ssh"
SSH_PRIVKEY_SRC="${SECRET_DIR}/sample-id_ecdsa"
SSH_PRIVKEY_DST="${SSHDIR}/id_ecdsa"

OPENSSL_PACKAGE_NAME=
MAKE_NUM_JOBS=4

# override
CONFIG_OVERRIDE=${CONF_DIR}/config.sh
if [ -f "$CONFIG_OVERRIDE" ]; then
    source "$CONFIG_OVERRIDE"
fi

SUDO_USER() {
    sudo -u $ANSIBLE_USER "$@"
}

DONE() {
    echo "DONE: $@"
}
