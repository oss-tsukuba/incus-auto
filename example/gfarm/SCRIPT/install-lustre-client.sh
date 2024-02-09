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

SUDO yum --nogpgcheck --enablerepo=e2fsprogs-wc upgrade -y \
     e2fsprogs
SUDO yum --nogpgcheck --enablerepo=lustre-client install -y \
     kmod-lustre-client lustre-client

# TODO install gfarm clinet
