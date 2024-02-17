set -eu

source /etc/os-release

CONF_DIR=/CONF
SCRIPT_DIR=/SCRIPT
SECRET_DIR=/SECRET  # secret dir for management host
INV=${SECRET_DIR}/CACHE/tmp-inventory.yaml

SYS_USER=gfarmsys  # incus-auto.yaml:/config/user
HOMEDIR="/home/${SYS_USER}"
SSHDIR="${HOMEDIR}/.ssh"
SSH_PRIVKEY_SRC="${SECRET_DIR}/sample-id_ecdsa"
SSH_PRIVKEY_DST="${SSHDIR}/id_ecdsa"
SSH_CONFIG_SRC="${SECRET_DIR}/ssh_config"
SSH_CONFIG_DST="${SSHDIR}/config"

OPENSSL_PACKAGE_NAME=
MAKE_NUM_JOBS=4

# override
CONFIG_OVERRIDE=${CONF_DIR}/config.sh
if [ -f "$CONFIG_OVERRIDE" ]; then
    source "$CONFIG_OVERRIDE"
fi

SUDO() {
    sudo --preserve-env=http_proxy,https_proxy "$@"
}

DONE() {
    echo "DONE: $@"
}

MYIP() {
    local IF
    IF=`ip route | awk '/^default/ { print $5 }'`
    ip addr show $IF | awk '/inet / {print $2}' | cut -d '/' -f 1
}

BACKUP_RESTORE() {
    local FILE="$1"
    local ORIG="${FILE}.orig"
    if [ -f "$ORIG" ]; then
        SUDO cp -af "$ORIG" "$FILE"
    else
        SUDO cp -an "$FILE" "$ORIG"
    fi
}

INSTALL_RPM() {
    local ARGS=""
    local A

    for A in "$@"; do
        ARGS="$ARGS ${A}-[0-9]*.rpm"
    done
    SUDO rpm -ivh --force $ARGS
}

REGPATH_usrlocalbin() {
    profile=/etc/profile.d/usrlocalbin.sh
    if [ ! -f $profile ]; then
        cat <<EOF | SUDO tee $profile
export PATH=$PATH:/usr/local/bin
EOF
    fi
    source $profile
}
