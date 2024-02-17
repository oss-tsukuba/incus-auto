#!/bin/sh

set -eu
set -x

TARGET="$1"
shift

cd /CONF

# ex. --extra-vars gfarm_install=yes
EXTRA=

LIMIT=
case $TARGET in
    gfarm)
        LIMIT="--limit !lustre"
        ;;
    lustre)
        LIMIT="--limit !gfarm"
        ;;
esac

ansible-playbook $EXTRA -i inventories.yaml $LIMIT playbook-gfarm.yaml -vv "$@"
