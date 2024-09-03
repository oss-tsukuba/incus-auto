#!/bin/bash

set -eu
set -x

TEST_COUNT=${1:-10}

TESTFILE=/tmp/testfile
LUSTRE_DIR=/mnt/lustre
#HSMDIR=/tmp/hsmtest
HSMDIR=/mnt/gfarm-lustre-hsm
GFARM_USER=gfarmsys

T=${LUSTRE_DIR}${TESTFILE}
A=${HSMDIR}/shadow${TESTFILE}

clean() {
    echo rm -f "$T"
}

trap clean EXIT

state() {
    EXPECT="$1"
    EXPECT_EXIST="$2"
    while :; do
	if lfs hsm_state $T | grep -q "$EXPECT"; then
	    break
	fi
	lfs hsm_state $T
	sleep 0.2
    done
    lfs hsm_state $T

    RETRY=5
    RESULT=3
    for j in $(seq $RETRY); do
	L=$(dirname $A)/$(readlink $A)
	ls -l $A
	if $EXPECT_EXIST; then
	    if [ -f $L ]; then
		ls -l $L
		RESULT=0
		break
	    else
		echo >&2 "Error: unexpected condition 1"
		RESULT=1
	    fi
	else
	    if [ -e $L ]; then
		echo >&2 "Error: unexpected condition 2"
		ls -l $L
		RESULT=2
	    else
		RESULT=0
		break
	    fi
	fi
	sleep 1
    done
    if [ $RESULT -ne 0 ]; then
	exit $RESULT
    fi
}

archive() {
    lfs hsm_archive $T
    state ") exists archived, archive_id" true
}

release() {
    lfs hsm_release $T
    state ") released exists archived, archive_id" true
}

restore() {
    lfs hsm_restore $T
    state ") exists archived, archive_id" true
}

restore_read() {
    cat $T
    state ") exists archived, archive_id" true
}

remove() {
    lfs hsm_remove $T
    state "0x00000000)," false
}

rm -f $T
date > $T
chown ${GFARM_USER}:${GFARM_USER} $T

for i in $(seq ${TEST_COUNT}); do
    echo "########## test count=$i ###########"
    archive
    release
    restore
    release
    restore_read
    remove
    echo "test count=$i ... PASS"
done

echo "ALL ... PASS"
