#!/bin/bash

source /SCRIPT/lib.sh

MNT_LUSTRE=/mnt/lustre
HSM_ROOT=/tmp/gfarmsys/LustreHSM
LUSTRE_SRC_ORIG=/SRC/lustre-release
LUSTRE_SRC=~/lustre-release
HSM_POSIX_DIR=${LUSTRE_SRC}/hsm-posix
HSMTOOL=${HSM_POSIX_DIR}/lhsmtool_posix

#DAEMON=--daemon
DAEMON=

rsync -av --delete $LUSTRE_SRC_ORIG/ $LUSTRE_SRC/

if [ ! -e "$HSM_POSIX_DIR" ]; then
    cat <<EOF
${HSM_POSIX_DIR}: Not found
See README-gfarm.md
EOF
    exit 1
fi

[ -f "$HSMTOOL" ] || (cd "$HSM_POSIX_DIR" && ./build.sh)

BACKUP_RESTORE /etc/fuse.conf
echo "user_allow_other" | SUDO tee -a /etc/fuse.conf

umount.gfarm2fs || true
FUSE_OPTIONS="-o allow_root" mount.gfarm2fs

mkdir -p $HSM_ROOT

SUDO $HSMTOOL $DAEMON --hsm-root $HSM_ROOT --archive=1 $MNT_LUSTRE
