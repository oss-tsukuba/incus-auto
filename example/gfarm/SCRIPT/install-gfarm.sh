#!/bin/bash

source /SCRIPT/lib.sh

BUILD_CACHE=false
USE_CACHE=false
DISTCLEAN=true
UPDATE_PACKAGE=true
INSTALL_MANPAGE=true
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
        --build-cache)
            BUILD_CACHE=true
            DISTCLEAN=true
            ;;
        --use-cache)
            USE_CACHE=true
            DISTCLEAN=false
            ;;
        --no-manpage)
            INSTALL_MANPAGE=false
            ;;
    esac
done

###################################################################

install_package_debian() {
    # for install-gfarm.sh
    APTGET install -y \
	 rsync

    # for developer
    APTGET update
    APTGET install -y \
	 git \
	 less \
	 emacs-nox \
	 vim \
	 gdb \
	 valgrind

    # for Gfarm (from INSTALL.en)
    APTGET install -y \
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
    APTGET install -y \
	 make

    # for scitokens-cpp
    APTGET install -y \
	 g++ \
	 cmake \
	 libcurl4-openssl-dev \
	 uuid-dev \
	 libsqlite3-dev

    # for GSI environment
    APTGET install -y \
	 globus-gsi-cert-utils-progs \
	 myproxy
}

install_package_rhel() {
    # base package
    DNF install -y \
	 rsync

    # for developer
    DNF install -y \
	 git \
	 less \
	 emacs-nox \
	 vim \
	 gdb \
	 valgrind

    # for Gfarm (from INSTALL.en)
    DNF install -y epel-release
    DNF install -y \
	 openssl-devel \
	 postgresql-devel \
	 cyrus-sasl-devel \
	 krb5-devel \
	 globus-gssapi-gsi-devel \
	 pkgconfig \
	 rdma-core-devel \
	 postgresql postgresql-server \
	 fuse fuse-devel libacl-devel \
	 python3 python3-docopt python3-schema \
	 ruby \
	 golang

    # to build gfarm
    DNF install -y \
	 make

    # for scitokens-cpp
    DNF install -y \
	 gcc-c++ \
	 cmake \
	 libcurl-devel \
	 libuuid-devel \
	 sqlite-devel

    # for cyrus-sasl-xoauth2-idp
    DNF install -y \
	 libtool


    # for GSI environment
    DNF install -y \
	 globus-gsi-cert-utils-progs \
	 myproxy
}

clean_package_debian() {
    APTGET autoclean -y
    APTGET autoremove -y
}

clean_package_rhel() {
    DNF clean -y all
}

for id in $ID_LIKE; do  # ID_LIKE from /etc/os-release
    case $id in
        debian)
            install_package=install_package_debian
            clean_package=clean_package_debian
            break
            ;;
        rhel)
            install_package=install_package_rhel
            clean_package=clean_package_rhel
            REGPATH_usrlocalbin
            break
            ;;
    esac
done

###################################################################
if $UPDATE_PACKAGE; then
    $install_package
fi

###################################################################
GFARM_SRCDIR=/SRC/gfarm
GFARM_WORKDIR=${HOME}/gfarm
CACHE_DIR=/CACHE/${ID}/gfarm  # ID from /etc/os-release

RSYNC_OPT=
if $DISTCLEAN; then
    RSYNC_OPT="--delete --exclude docker/dev/mnt"
fi

mkdir -p $GFARM_WORKDIR
if $USE_CACHE; then
    rsync -a $RSYNC_OPT ${CACHE_DIR}/ ${GFARM_WORKDIR}/
else
    rsync -a $RSYNC_OPT ${GFARM_SRCDIR}/ ${GFARM_WORKDIR}/
fi

###################################################################
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

if $INSTALL_MANPAGE; then
    SUDO make install
else
  (cd include/gfarm && SUDO make install)
  (cd lib && SUDO make install)
  (cd gftool && SUDO make install)
  (cd pkgconfig && SUDO make install)
fi

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
$DISTCLEAN && rm -rf build
mkdir -p build
cd build
scitokens_prefix=/usr
cmake -DCMAKE_INSTALL_PREFIX="$scitokens_prefix" ..
make
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

###################################################################
if $BUILD_CACHE; then
    mkdir -p $CACHE_DIR
    rsync -a $RSYNC_OPT ${GFARM_WORKDIR}/ ${CACHE_DIR}/
fi

$clean_package
