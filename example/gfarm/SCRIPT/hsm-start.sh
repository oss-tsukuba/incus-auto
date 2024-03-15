#!/bin/bash

source /SCRIPT/lib.sh
set -x

MNT_LUSTRE=/mnt/lustre
GFS_MOUNTDIR=/mnt/gfarm-lustre-hsm
GFARMFS_ROOT=/LustreHSM
HSM_ROOT=${GFS_MOUNTDIR}
LUSTRE_SRC_ORIG=/SRC/lustre-release
LUSTRE_SRC=${HOME}/lustre-release
HSM_POSIX_DIR=${LUSTRE_SRC}/hsm-posix
ARCHIVE=1

USE_MOUNT_GFARM2FS_HSMTOOL=1
MOUNT_GFARM2FS_HSMTOOL=${HSM_POSIX_DIR}/mount-gfarm2fs-and-lhsmtool_posix.sh
HSMTOOL=${HSM_POSIX_DIR}/lhsmtool_posix

#DAEMON=--daemon
DAEMON=

clean() {
    GFS_MOUNTDIR=$GFS_MOUNTDIR GFARMFS_ROOT=$GFARMFS_ROOT \
		umount.gfarm2fs || true
}

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

if [ $USE_MOUNT_GFARM2FS_HSMTOOL -eq 1 ]; then
    sh -x "$MOUNT_GFARM2FS_HSMTOOL" "$GFS_MOUNTDIR" "$GFARMFS_ROOT" "$MNT_LUSTRE" $ARCHIVE
else
    clean
    trap clean EXIT
    gfmkdir -p $GFARMFS_ROOT
    SUDO mkdir -p $GFS_MOUNTDIR
    SUDO chown `whoami` $GFS_MOUNTDIR
    GFS_MOUNTDIR=$GFS_MOUNTDIR GFARMFS_ROOT=$GFARMFS_ROOT \
		FUSE_OPTIONS="-o allow_root" mount.gfarm2fs
    SUDO $HSMTOOL $DAEMON --hsm-root $HSM_ROOT --archive=$ARCHIVE $MNT_LUSTRE
fi
