#!/bin/bash

source /SCRIPT/lib.sh

MGS_IP="$1"
FSNAME="$2"

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

SUDO systemctl stop lnet || true
SUDO systemctl start lnet || true
SUDO lnetctl net show

MNTDIR=/mnt/lustre

if ! grep -q "$MNTDIR" /etc/fstab; then
    SUDO mkdir -p $MNTDIR

    cat <<EOF | SUDO tee -a /etc/fstab
${MGS_IP}@tcp:/${FSNAME} ${MNTDIR} lustre defaults,noatime,flock,_netdev,x-systemd.automount,x-systemd.requires=network.service 0 0
EOF
    SUDO systemctl daemon-reload
    #SUDO mount $MNTDIR
fi
