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
RETRY_CMD=5

CMD_ANSIBLE=~/.local/bin/ansible
CMD_PLAYBOOK=~/.local/bin/ansible-playbook

ANSIBLE_CONFIG=/CONF/ansible.cfg
export ANSIBLE_CONFIG

# override
CONFIG_OVERRIDE=${CONF_DIR}/config.sh
if [ -f "$CONFIG_OVERRIDE" ]; then
    source "$CONFIG_OVERRIDE"
fi

IS_ID_LIKE_DEBIAN() {
    for id in $ID_LIKE; do  # ID_LIKE from /etc/os-release
        case $id in
            debian)
                return 0
                ;;
        esac
    done
    return 1
}

PRESERVE_ENV="http_proxy,https_proxy"

if IS_ID_LIKE_DEBIAN; then
    export DEBIAN_FRONTEND=noninteractive
    PRESERVE_ENV+=",DEBIAN_FRONTEND"
fi

SUDO_CMD="sudo --preserve-env=${PRESERVE_ENV}"

SUDO() {
    $SUDO_CMD "$@"
}

_retry_cmd() {
    local rv=1
    for i in $(seq $RETRY_CMD); do
        if "$@"; then
            return 0
        fi
        rv=$?
    done
    return $rv
}

DNF() {
    _retry_cmd $SUDO_CMD dnf "$@"
}

APTGET() {
    _retry_cmd $SUDO_CMD apt-get "$@"
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
    local profile=/etc/profile.d/usrlocalbin.sh
    if [ ! -f $profile ]; then
        cat <<EOF | SUDO tee $profile
export PATH=$PATH:/usr/local/bin
EOF
    fi
    source $profile
}

ANSIBLE_LIMIT() {
    local TARGET="$1"
    local LIMIT=
    case $TARGET in
        gfarm)
            LIMIT="--limit control:gfarm:extra:!lustre"
            ;;
        lustre)
            LIMIT="--limit lustre"
            ;;
    esac
    echo $LIMIT
}
