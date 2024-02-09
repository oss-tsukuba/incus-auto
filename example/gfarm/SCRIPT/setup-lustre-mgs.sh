#!/bin/bash

source /SCRIPT/lib.sh

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

if ! df -h /mnt/mdt; then
    SUDO mkfs.lustre --fsname=temp --mgs --mdt --index=0 /dev/sdb
    SUDO mkdir -p /mnt/mdt
    #SUDO mount -t lustre /dev/sdb /mnt/mdt
fi

if ! grep -q "/mnt/mdt" /etc/fstab; then
    cat <<EOF | SUDO tee -a /etc/fstab
/dev/sdb  /mnt/mdt   lustre  defaults   0 0
EOF
    SUDO systemctl daemon-reload
    SUDO mount /mnt/mdt
fi
