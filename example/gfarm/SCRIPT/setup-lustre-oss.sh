#!/bin/bash

source /SCRIPT/lib.sh

INDEX="$1"
MGS_IP="$2"

IP=$(MYIP)
NETIF=enp5s0

cat <<EOF | SUDO tee /etc/lnet.conf
net:
    - net type: tcp
      local NI(s):
        - nid: ${IP}@tcp
          status: up
          interfaces:
              0: ${NETIF}
EOF

SUDO systemctl enable lnet
SUDO systemctl start lnet
SUDO lnetctl net show

BD=/dev/sdb
MNTDIR=/mnt/ost
FSNAME=test1

REFORMAT="--reformat"

if ! (mount | grep -q $MNTDIR); then
    SUDO mkfs.lustre --fsname=${FSNAME} --mgsnode=${MGS_IP}@tcp --ost --index=${INDEX} ${REFORMAT} ${BD}
    SUDO mkdir -p $MNTDIR
fi

if ! grep -q "$MNTDIR" /etc/fstab; then
    cat <<EOF | SUDO tee -a /etc/fstab
/dev/sdb  ${MNTDIR}   lustre  defaults   0 0
EOF
    SUDO systemctl daemon-reload
    SUDO mount $MNTDIR
fi
