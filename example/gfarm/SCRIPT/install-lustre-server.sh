#!/bin/bash

source /SCRIPT/lib.sh
source /SCRIPT/install-lustre-common.sh

cat <<EOF | SUDO tee /etc/yum.repos.d/lustre.repo
[lustre-server]
name=lustre-server
#baseurl=http://metaserver/repo/lustre-server
baseurl=http://downloads.whamcloud.com/public/lustre/latest-release/${EL_VERSION}/server
enabled=0
gpgcheck=0
proxy=_none_

[lustre-client]
name=lustre-client
#baseurl=http://metaserver/repo/lustre-client
baseurl=http://downloads.whamcloud.com/public/lustre/latest-release/${EL_VERSION}/client
enabled=0
gpgcheck=0

[e2fsprogs-wc]
name=e2fsprogs-wc
#baseurl=http://metaserver/repo/e2fsprogs-wc
baseurl=http://downloads.whamcloud.com/public/e2fsprogs/latest/el8
enabled=0
gpgcheck=0
EOF

install_lustre_yum() {
    DNF --nogpgcheck --enablerepo=lustre-server install -y \
	 --skip-broken \
	 kmod-lustre kmod-lustre-osd-ldiskfs lustre-osd-ldiskfs-mount \
	 lustre lustre-resource-agents
    DNF --nogpgcheck --disablerepo=* \
	 --enablerepo=e2fsprogs-wc install -y \
	 e2fsprogs
}

install_lustre_rpm() {
    cache_rpm ${E2FSPROGS_DIR} ${E2FSPROGS_URL} 6
    (cd $E2FSPROGS_DIR && \
         INSTALL_RPM e2fsprogs e2fsprogs-libs libcom_err libss
    )

    cache_rpm ${LUSTRE_SERVER_DIR} ${LUSTRE_SERVER_URL} 7
    (cd $LUSTRE_SERVER_DIR && \
         INSTALL_RPM \
             kernel-core \
             kmod-lustre \
             kmod-lustre-osd-ldiskfs \
             lustre-osd-ldiskfs-mount \
             lustre
    )
    #lustre-resource-agents  # not installed even if using yum
}

install_lustre_common

#install_lustre_yum
install_lustre_rpm

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
BACKUP_RESTORE $GRUB_ENV
cat <<EOF | SUDO tee -a $GRUB_ENV
GRUB_DISABLE_SUBMENU=true
GRUB_DEFAULT=2
#GRUB_TIMEOUT=10
EOF

# $ID: from /etc/os-release
SUDO grub2-mkconfig -o /boot/efi/EFI/${ID}/grub.cfg

REGPATH_usrlocalbin
