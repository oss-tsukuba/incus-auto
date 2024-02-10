#!/bin/bash

LUSTRE_VER=lustre-2.15.4
DIST=el8.9
E2FSPROGS_VER=1.47.0.wc6

E2FSPROGS_DIR=/CACHE/e2fsprogs-${E2FSPROGS_VER}
LUSTRE_SERVER_DIR=/CACHE/${LUSTRE_VER}-server
LUSTRE_CLIENT_DIR=/CACHE/${LUSTRE_VER}-client

# for rpm
LUSTRE_SERVER_URL=https://downloads.whamcloud.com/public/lustre/${LUSTRE_VER}/${DIST}/server/RPMS/x86_64/
LUSTRE_CLIENT_URL=https://downloads.whamcloud.com/public/lustre/${LUSTRE_VER}/${DIST}/client/RPMS/x86_64/
E2FSPROGS_URL=https://downloads.whamcloud.com/public/e2fsprogs/${E2FSPROGS_VER}/el8/RPMS/x86_64/

install_lustre_common() {
    # for developer
    SUDO yum install -y \
	 less \
	 emacs-nox \
	 vim
    # gdb \
    # valgrind

    SUDO yum install -y \
         perl-interpreter \
         libnl3
}

cache_rpm() {
    local OUTDIR="$1"
    local URL="$2"
    local CUTDIR_INDEX="$3"

    mkdir -p $OUTDIR
    which wget || SUDO yum install -y wget

    # default: downloads.whamcloud.com/public/lustre/lustre-2.15.4/el8.9/server/RPMS/x86_64/
    # -nH : public/lustre/lustre-2.15.4/el8.9/server/RPMS/x86_64/
    # --cut-dir=7
    wget -r --no-parent --no-clobber --continue \
         --no-host-directories --cut-dir=${CUTDIR_INDEX} \
         --accept '.rpm' \
         --reject '*-debuginfo-*' \
         --reject '*-debugsource-*' \
         --reject '*-tests-*' \
         -P $OUTDIR $URL
    wget -O ${OUTDIR}/sha256sum ${URL}/sha256sum

    grep -v -- '-debuginfo-' ${OUTDIR}/sha256sum > ${OUTDIR}/sha256sum-1
    grep -v -- '-debugsource-' ${OUTDIR}/sha256sum-1 > ${OUTDIR}/sha256sum-2
    grep -v -- '-tests-' ${OUTDIR}/sha256sum-2 > ${OUTDIR}/sha256sum-3
    (cd $OUTDIR && sha256sum -c sha256sum-3)
}