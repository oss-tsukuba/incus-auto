#!/bin/sh

set -eux

LOG1=
LOG2=
LOG3=

clean() {
    [ -f "$LOG1" ] && rm -f $LOG1
    [ -f "$LOG2" ] && rm -f $LOG2
#    [ -f "$LOG3" ] && rm -f $LOG3
}

trap clean EXIT

LOG1=$(mktemp)
LOG2=$(mktemp)
#LOG3=$(mktemp)

make CLEAN
make show-config-all
make init

(make build-gfarm && make launch-gfarm) > $LOG1 2>&1 &
(./build-lustre.sh build && ./build-lustre.sh launch) > $LOG2 2>&1 &
wait
cat $LOG1 $LOG2

make setup-gfarm-all
#make setup-gfperf
