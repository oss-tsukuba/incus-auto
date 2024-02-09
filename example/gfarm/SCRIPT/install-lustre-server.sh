#!/bin/bash

source /SCRIPT/lib.sh

# for developer
SUDO yum install -y \
     less \
     emacs-nox \
     vim
     # gdb \
     # valgrind

cat <<EOF | SUDO tee /etc/yum.repos.d/lustre.repo
[lustre-server]
name=lustre-server
#baseurl=http://metaserver/repo/lustre-server
baseurl=https://downloads.whamcloud.com/public/lustre/latest-release/el8.9/server
enabled=0
gpgcheck=0
proxy=_none_

[lustre-client]
name=lustre-client
#baseurl=http://metaserver/repo/lustre-client
baseurl=https://downloads.whamcloud.com/public/lustre/latest-release/el8.9/client
enabled=0
gpgcheck=0

[e2fsprogs-wc]
name=e2fsprogs-wc
#baseurl=http://metaserver/repo/e2fsprogs-wc
baseurl=https://downloads.whamcloud.com/public/e2fsprogs/latest/el8
enabled=0
gpgcheck=0
EOF

SUDO yum --nogpgcheck --disablerepo=* --enablerepo=e2fsprogs-wc install -y \
     e2fsprogs
SUDO yum --nogpgcheck --enablerepo=lustre-server install -y \
     --skip-broken \
     kmod-lustre kmod-lustre-osd-ldiskfs lustre-osd-ldiskfs-mount \
     lustre lustre-resource-agents

if [ ! -f /etc/lnet.conf.orig ]; then
    SUDO mv /etc/lnet.conf /etc/lnet.conf.orig
fi

if ! grep -q 'exclude=kernel' /etc/yum.conf; then
    echo 'exclude=kernel*' | SUDO tee -a /etc/yum.conf
fi

### not work
# KERNEL=/boot/$(ls -t1 /boot/ | grep vmlinuz- | grep _lustre | head -1)
# SUDO grubby --set-default=${KERNEL}

GRUB_ENV=/etc/default/grub
if ! grep -q "GRUB_DISABLE_SUBMENU=true" $GRUB_ENV; then
    cat <<EOF | SUDO tee -a $GRUB_ENV
GRUB_DISABLE_SUBMENU=true
GRUB_DEFAULT=2
#GRUB_TIMEOUT=10
EOF
fi
SUDO grub2-mkconfig -o /boot/efi/EFI/rocky/grub.cfg
