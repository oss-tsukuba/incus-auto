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

trap clean EXIT

LOG1=$(mktemp)
LOG2=$(mktemp)
LOG3=$(mktemp)
LOG4=$(mktemp)

# SEE ALSO: incus-auto.lustre.yaml

case $TARGET in
    build)
        $B img-lserver > $LOG1 2>&1 &
        ($B tmp-gfarm-rocky && $B img-lclient) > $LOG2 2>&1 &
        wait
        cat $LOG1 $LOG2
        ;;
    launch)
        $C mgs > $LOG1 2>&1 &
        $C oss0 > $LOG2 2>&1 &
        $C oss1 > $LOG3 2>&1 &
        $C lclient1 > $LOG4 2>&1 &
        wait
        cat $LOG1 $LOG2 $LOG3
        $IA restart oss0 &
        $IA restart oss1 &
        wait
        $IA restart lclient
        ;;
esac
