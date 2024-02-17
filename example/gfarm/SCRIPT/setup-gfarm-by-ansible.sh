#!/bin/bash

set -eu
set -x

source /SCRIPT/lib.sh

TARGET="$1"
shift

cd /CONF

# ex. --extra-vars gfarm_install=yes
EXTRA=

LIMIT=
case $TARGET in
    gfarm)
        LIMIT="--limit control:gfarm:extra:!lustre"
        ;;
    lustre)
        LIMIT="--limit lustre"
        ;;
esac

ansible-playbook $EXTRA -i $INV $LIMIT playbook-gfarm.yaml -vv "$@"
