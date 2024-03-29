#!/bin/bash

source /SCRIPT/lib.sh

FSNAME="$1"

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
SUDO systemctl stop lnet || true
SUDO systemctl start lnet || true
SUDO lnetctl net show

MNTDIR=/mnt/mdt
BD=/dev/sdb

if ! df -h /mnt/mdt; then
    SUDO mkfs.lustre --fsname=${FSNAME} --mgs --mdt --index=0 ${BD}
    SUDO mkdir -p ${MNTDIR}
fi

if ! grep -q "$MNTDIR" /etc/fstab; then
    cat <<EOF | SUDO tee -a /etc/fstab
${BD}  ${MNTDIR}   lustre  defaults   0 0
EOF
    SUDO systemctl daemon-reload
    SUDO mount $MNTDIR
fi
