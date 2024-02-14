#!/bin/bash

source /SCRIPT/lib.sh

SUDO apt-get install -y squid

SQUID_CONF=/etc/squid/squid.conf

BACKUP_RESTORE $SQUID_CONF

SUDO sed -i '/http_access allow localhost/ ahttp_access allow localnet' $SQUID_CONF

cat <<EOF | SUDO tee -a $SQUID_CONF
shutdown_lifetime 3 seconds
EOF

SUDO systemctl restart squid
