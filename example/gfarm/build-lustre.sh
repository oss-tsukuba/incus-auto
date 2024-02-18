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
}

mkt() {
    mktemp tmp.XXXXXXXXXX.${1}
}

trap clean EXIT

# SEE ALSO: incus-auto.lustre.yaml

case $TARGET in
    build)
        LOG1=$(mkt IMG-lserver)
        LOG2=$(mkt IMG-lclient)

        $B IMG-lserver > $LOG1 2>&1 &
        p1=$!
        ($B TMP-gfarm-rocky && $B IMG-lclient) > $LOG2 2>&1 &
        p2=$!
        tail -f $LOG1 $LOG2 &
        t=$!
        ERR=0
        wait $p1 $p2 || ERR=$?
        cat $LOG1 $LOG2
        kill -9 $t || true
        wait || true
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
        ERR=0
        wait $p1 $p2 $p3 $p4 || ERR=$?
        cat $LOG1 $LOG2 $LOG3 $LOG4
        kill -9 $t || true
        wait || true
        $IA restart oss0 &
        $IA restart oss1 &
        wait || true
        $IA restart lclient
        ;;
esac

if [ $ERR -ne 0 ]; then
    exit $ERR
fi
