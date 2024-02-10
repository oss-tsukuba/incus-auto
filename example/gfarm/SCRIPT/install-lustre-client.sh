#!/bin/bash

source /SCRIPT/lib.sh
source /SCRIPT/install-lustre-common.sh

# for developer
SUDO yum install -y \
     less \
     emacs-nox \
     vim
     # gdb \
     # valgrind

cat <<EOF | SUDO tee /etc/yum.repos.d/lustre.repo
[lustre-client]
name=lustre-client
#baseurl=http://metaserver/repo/lustre-client
baseurl=http://downloads.whamcloud.com/public/lustre/latest-release/el8.9/client
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
    SUDO yum --nogpgcheck --enablerepo=e2fsprogs-wc upgrade -y \
         e2fsprogs
    SUDO yum --nogpgcheck --enablerepo=lustre-client install -y \
         kmod-lustre-client lustre-client
}

install_lustre_rpm() {
    cache_rpm ${E2FSPROGS_DIR} ${E2FSPROGS_URL} 6
    cache_rpm ${LUSTRE_CLIENT_DIR} ${LUSTRE_CLIENT_URL} 7
    (cd $E2FSPROGS_DIR && \
         INSTALL_RPM e2fsprogs e2fsprogs-libs libcom_err libss
    )
    (cd $LUSTRE_CLIENT_DIR && \
         INSTALL_RPM kmod-lustre-client lustre-client
    )
}

install_lustre_common

#install_lustre_yum
install_lustre_rpm

REGPATH_usrlocalbin
