#!/bin/bash

# SEE: http://downloads.whamcloud.com/public/lustre/
LUSTRE_VER=lustre-2.15.5

# SEE: https://downloads.whamcloud.com/public/e2fsprogs/
E2FSPROGS_VER=1.47.1.wc1

EL_VERSION=el${VERSION_ID}  # from /etc/os-release
DIST=${EL_VERSION}

EL_VER_MAJOR=$(echo $EL_VERSION | cut -d '.' -f 1)

E2FSPROGS_DIR=/CACHE/e2fsprogs-${E2FSPROGS_VER}
LUSTRE_SERVER_DIR=/CACHE/${LUSTRE_VER}-server
LUSTRE_CLIENT_DIR=/CACHE/${LUSTRE_VER}-client

# to get rpm (not using yum)
LUSTRE_SERVER_URL=http://downloads.whamcloud.com/public/lustre/${LUSTRE_VER}/${DIST}/server/RPMS/x86_64/
LUSTRE_CLIENT_URL=http://downloads.whamcloud.com/public/lustre/${LUSTRE_VER}/${DIST}/client/RPMS/x86_64/
E2FSPROGS_URL=https://downloads.whamcloud.com/public/e2fsprogs/${E2FSPROGS_VER}/${EL_VER_MAJOR}/RPMS/x86_64/

install_lustre_common() {
    # for developer
    DNF install -y \
	 less \
	 emacs-nox \
	 vim
    # gdb \
    # valgrind

    # for lustre
    DNF install -y \
         perl-interpreter \
         libnl3

    # for ansible
    DNF install -y \
	python3
}

WGET="wget --tries=5"

cache_rpm() {
    local OUTDIR="$1"
    local URL="$2"
    local CUTDIR_INDEX="$3"

    mkdir -p $OUTDIR
    which wget || DNF install -y wget

    $WGET -r --no-parent --no-clobber --continue \
         --no-host-directories --cut-dir=${CUTDIR_INDEX} \
         --accept '.rpm' \
         --reject '*-debuginfo-*' \
         --reject '*-debugsource-*' \
         --reject '*-tests-*' \
         -P $OUTDIR $URL
    $WGET -O ${OUTDIR}/sha256sum ${URL}/sha256sum

    grep -v -- '-debuginfo-' ${OUTDIR}/sha256sum > ${OUTDIR}/sha256sum-1
    grep -v -- '-debugsource-' ${OUTDIR}/sha256sum-1 > ${OUTDIR}/sha256sum-2
    grep -v -- '-tests-' ${OUTDIR}/sha256sum-2 > ${OUTDIR}/sha256sum-3
    (cd $OUTDIR && sha256sum -c sha256sum-3)
}
