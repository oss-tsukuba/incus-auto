#!/bin/sh

set -eu
set -x

GFARM_SRC_WORK=${HOME}/gfarm
CONFIG_MK=$GFARM_SRC_WORK/docker/dev/config.mk

sudo rsync -av --delete --exclude docker/dev/mnt /GFARM/ ${GFARM_SRC_WORK}/
sudo chown -R admin $GFARM_SRC_WORK

if [ ! -f $CONFIG_MK ]; then
    cat <<EOF > $CONFIG_MK
GFDOCKER_SASL_USE_KEYCLOAK = true
EOF
fi
