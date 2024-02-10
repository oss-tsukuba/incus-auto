#!/bin/bash

source /SCRIPT/lib.sh

USE_CACHE=false
DISTCLEAN=true
UPDATE_PACKAGE=true
for arg in "$@"; do
    echo $arg
    case "$arg" in
        --reinstall)
            DISTCLEAN=false
            UPDATE_PACKAGE=false
            ;;
        --no-distclean)
            DISTCLEAN=false
            ;;
        --no-update-package)
            UPDATE_PACKAGE=false
            ;;
        --use-cache)
            USE_CACHE=true
            ;;
    esac
done

###################################################################

install_package_debian() {
    # base package
    SUDO apt-get install -y \
	 rsync

    # for developer
    SUDO apt-get update
    SUDO apt-get install -y \
	 git \
	 less \
	 emacs-nox \
	 vim \
	 gdb \
	 valgrind

    # for Gfarm (from INSTALL.en)
    SUDO apt-get install -y \
	 libssl-dev \
	 libpq-dev \
	 libsasl2-dev \
	 sasl2-bin \
	 libkrb5-dev \
	 libglobus-gssapi-gsi-dev \
	 pkg-config \
	 libibverbs-dev \
	 postgresql \
	 postgresql-client \
	 libfuse-dev \
	 libacl1-dev \
	 python3 \
	 python3-docopt \
	 python3-schema \
	 ruby \
	 golang

    # to build gfarm
    SUDO apt-get install -y \
	 make

    # for scitokens-cpp
    SUDO apt-get install -y \
	 g++ \
	 cmake \
	 libcurl4-openssl-dev \
	 uuid-dev \
	 libsqlite3-dev

    # for GSI environment
    SUDO apt-get install -y \
	 globus-gsi-cert-utils-progs \
	 myproxy
}

install_package_rhel() {
    # base package
    SUDO dnf install -y \
	 rsync

    # for developer
    SUDO dnf install -y \
	 git \
	 less \
	 emacs-nox \
	 vim \
	 gdb \
	 valgrind

    # for Gfarm (from INSTALL.en)
    SUDO dnf install -y epel-release
    SUDO dnf install -y \
	 openssl-devel \
	 postgresql-devel \
	 cyrus-sasl-devel \
	 krb5-devel \
	 globus-gssapi-gsi-devel \
	 pkgconfig \
	 rdma-core-devel \
	 postgresql postgresql-server \
	 fuse-devel libacl-devel \
	 python3 python3-docopt python3-schema \
	 ruby \
	 golang

    # to build gfarm
    SUDO dnf install -y \
	 make

    # for scitokens-cpp
    SUDO dnf install -y \
	 gcc-c++ \
	 cmake \
	 libcurl-devel \
	 libuuid-devel \
	 sqlite-devel

    # for cyrus-sasl-xoauth2-idp
    SUDO dnf install -y \
	 libtool


    # for GSI environment
    SUDO dnf install -y \
	 globus-gsi-cert-utils-progs \
	 myproxy
}

if $UPDATE_PACKAGE; then
    for id in $ID_LIKE rhel; do  # ID_LIKE from /etc/os-release
        case $id in
            debian)
                install_package_debian
                break  # from id
                ;;
            rhel)
                install_package_rhel
                break  # from id
                ;;
        esac
    done
fi

for id in $ID_LIKE rhel; do  # ID_LIKE from /etc/os-release
    case $id in
        debian)
            break  # from id
            ;;
        rhel)
            REGPATH_usrlocalbin
            break  # from id
            ;;
    esac
done

###################################################################
GFARM_SRCDIR=/SRC/gfarm

if $USE_CACHE; then
    GFARM_WORKDIR=/CACHE/${ID}/gfarm  # ID from /etc/os-release
else
    GFARM_WORKDIR=${HOME}/gfarm
fi

RSYNC_OPT=
if $DISTCLEAN; then
    RSYNC_OPT="--delete"
fi
mkdir -p ${GFARM_WORKDIR}
rsync -a $RSYNC_OPT ${GFARM_SRCDIR}/ ${GFARM_WORKDIR}/

# install gfarm
cd $GFARM_WORKDIR
WITH_OPENSSL_OPT=
if [ -n "${OPENSSL_PACKAGE_NAME}" ]; then
    WITH_OPENSSL_OPT="--with-openssl=${OPENSSL_PACKAGE_NAME}"
fi
GFARM_OPT="--with-globus=/usr --enable-xmlattr ${WITH_OPENSSL_OPT}"
$DISTCLEAN && (test -f Makefile && make distclean || true)
$DISTCLEAN && ./configure $GFARM_OPT
make -j $MAKE_NUM_JOBS
SUDO make install

SUDO useradd -m _gfarmfs || true
SUDO useradd -m _gfarmmd || true

###################################################################
# install gfarm2fs
cd $GFARM_WORKDIR
cd gfarm2fs
$DISTCLEAN && (test -f Makefile && make distclean || true)
$DISTCLEAN && ./configure --with-gfarm=/usr/local
make -j $MAKE_NUM_JOBS
SUDO make install
if [ ! -f /sbin/mount.gfarm2fs ]; then
    # for autofs
    p=$(which mount.gfarm2fs)
    SUDO ln -s "$p" /sbin/
fi

###################################################################
# install jwt-logon
cd $GFARM_WORKDIR
cd jwt-logon
SUDO make PREFIX=/usr/local install

###################################################################
# install jwt-agent
cd $GFARM_WORKDIR
cd jwt-agent
make
SUDO make PREFIX=/usr/local install

###################################################################
# install scitokens-cpp

cd $GFARM_WORKDIR
cd scitokens-cpp
rm -rf build
mkdir -p build
cd build
scitokens_prefix=/usr
cmake -DCMAKE_INSTALL_PREFIX="$scitokens_prefix" ..
make -j $MAKE_NUM_JOBS
SUDO make install

###################################################################
# install cyrus-sasl-xoauth2-idp
cd $GFARM_WORKDIR
cd cyrus-sasl-xoauth2-idp
# autoconf at least until version 2.69 does not detect /usr/lib64
# automatically as ${libdir}, thus detect it by myself
pkg-config --exists libsasl2
sasl_libdir=$(pkg-config --variable=libdir libsasl2)
[ -f /usr/include/sasl/sasl.h -a \
     -f ${scitokens_prefix}/include/scitokens/scitokens.h ]
# NOTE: this installs to /usr/lib64/sasl2/ instead of
# /usr/local/lib64/sasl2/
$DISTCLEAN && ./autogen.sh
$DISTCLEAN && ./configure --libdir="${sasl_libdir}"
make -j $MAKE_NUM_JOBS
SUDO make install

DONE "$0" "$@"
