#!/bin/bash

set -eux

TARGET="$1"

IA=./IA.sh
B=./REBUILD.sh
C=./RECREATE.sh

LOG1=
LOG2=
LOG3=
LOG4=

clean() {
    [ -f "$LOG1" ] && rm -f $LOG1
    [ -f "$LOG2" ] && rm -f $LOG2
    [ -f "$LOG3" ] && rm -f $LOG3
    [ -f "$LOG4" ] && rm -f $LOG4
    return 0
}

mkt() {
    mktemp tmp.XXXXXXXXXX.${1}
}

trap clean EXIT

wp() {
    t="$1"
    shift
    ERR=0
    for p in "$@"; do
        wait $p || ERR=$?
    done
    kill -9 $t || true
    wait || true
    for L in $LOG1 $LOG2 $LOG3 $LOG4; do
        if [ -f "$L" ]; then
            echo "----- $L -----"
            cat $L
        fi
    done
    return $ERR
}

# SEE ALSO: incus-auto.lustre.yaml

case $TARGET in
    test)
        LOG1=$(mkt IMG-lserver)
        LOG2=$(mkt IMG-lclient)

        (sleep 5; echo sleep 5) > $LOG1 2>&1 &
        p1=$!
        (sleep 6; echo sleep 6; exit 3) > $LOG2 2>&1 &
        p2=$!
        tail -f $LOG1 $LOG2 &
        t=$!
        wp $t $p1 $p2
        ERR=$?
        ;;
    build)
        LOG1=$(mkt IMG-lserver)
        LOG2=$(mkt IMG-lclient)

        $B IMG-lserver > $LOG1 2>&1 &
        p1=$!
        ($B TMP-gfarm-rocky && $B IMG-lclient) > $LOG2 2>&1 &
        p2=$!
        tail -f $LOG1 $LOG2 &
        t=$!
        wp $t $p1 $p2
        ERR=$?
        ;;
    launch)
        LOG1=$(mkt mgs)
        LOG2=$(mkt oss0)
        LOG3=$(mkt oss1)
        LOG4=$(mkt lclient1)

        $C mgs > $LOG1 2>&1 &
        p1=$!
        $C oss0 > $LOG2 2>&1 &
        p2=$!
        $C oss1 > $LOG3 2>&1 &
        p3=$!
        $C lclient1 > $LOG4 2>&1 &
        p4=$!
        tail -f $LOG1 $LOG2 $LOG3 $LOG4 &
        t=$!
        wp $t $p1 $p2 $p3 $p4
        ERR=$?
        $IA restart oss0 &
        $IA restart oss1 &
        wait
        $IA restart lclient1
        ;;
    *)
        exit 1
        ;;
esac

if [ $ERR -ne 0 ]; then
    exit $ERR
fi
exit 0
