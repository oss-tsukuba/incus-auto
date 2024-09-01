#!/bin/bash

source /SCRIPT/lib.sh
set -x

MNT_LUSTRE=/mnt/lustre
GFS_MOUNTDIR=/mnt/gfarm-lustre-hsm
GFARMFS_ROOT=/LustreHSM
GFS_USERNAME=gfarmsfs  # global user in Gfarm
GFARMFS_USERNAME=gfarmsys  # local user
HSM_ROOT=${GFS_MOUNTDIR}
LUSTRE_SRC_ORIG=/SRC/lustre-release
LUSTRE_SRC=/home/${GFARMFS_USERNAME}/lustre-release
HSM_POSIX_DIR=${LUSTRE_SRC}/hsm-posix

HSM_ARCHIVE=1

#HSM_OPTIONS="--no-attr"
HSM_OPTIONS=""

MOUNT_GFARM2FS_HSMTOOL=${HSM_POSIX_DIR}/mount-gfarm2fs-and-lhsmtool_posix.sh
HSMTOOL=${HSM_POSIX_DIR}/lhsmtool_posix

RUN="runuser -u $GFARMFS_USERNAME --"

$RUN rsync -av --delete $LUSTRE_SRC_ORIG/ $LUSTRE_SRC/

if [ ! -e "$HSM_POSIX_DIR" ]; then
    cat <<EOF
${HSM_POSIX_DIR}: Not found
See README-gfarm.md
EOF
    exit 1
fi

[ -f "$HSMTOOL" ] || (cd "$HSM_POSIX_DIR" && $RUN ./build.sh)

BACKUP_RESTORE /etc/fuse.conf
echo "user_allow_other" | tee -a /etc/fuse.conf

mkdir -p $GFS_MOUNTDIR
chmod 700 $GFS_MOUNTDIR
chown $GFARMFS_USERNAME $GFS_MOUNTDIR

sh -x "$MOUNT_GFARM2FS_HSMTOOL" "$GFS_MOUNTDIR" "$GFARMFS_ROOT" "$GFS_USERNAME" "$GFARMFS_USERNAME" "$MNT_LUSTRE" "$HSM_ARCHIVE" "$HSM_OPTIONS"
