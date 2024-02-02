#!/bin/bash

source /SCRIPT/lib.sh

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
    esac
done

###################################################################

install_package_debian() {
    # for developer
    SUDO apt-get update
    SUDO apt-get install -y \
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
	    cmake \
	    libcurl4-openssl-dev \
	    uuid-dev \
	    libsqlite3-dev
}

if $UPDATE_PACKAGE; then
    for id in $ID_LIKE rhel; do  # from /etc/os-release
        case $id in
            debian)
                install_package_debian
                break  # for id
                ;;
            rhel)
                install_package_rhel
                break  # for id
                ;;
        esac
    done
fi

###################################################################
GFARM_WORKDIR=/SRC/gfarm

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
# for autofs
SUDO cp -af $(which mount.gfarm2fs) /sbin/

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
make
SUDO make install

DONE "$0" "$@"
