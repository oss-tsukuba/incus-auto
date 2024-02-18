#!/bin/sh

set -eux

LOG1=
LOG2=

clean() {
    [ -f "$LOG1" ] && rm -f $LOG1
    [ -f "$LOG2" ] && rm -f $LOG2
}

mkt() {
    mktemp tmp.XXXXXXXXXX.${1}
}

trap clean EXIT

LOG1=$(mkt gfarm)
LOG2=$(mkt lustre)

make CLEAN
make show-config-all
make init

(make build-gfarm && make launch-gfarm) > $LOG1 2>&1 &
p1=$!
(./build-lustre.sh build && ./build-lustre.sh launch) > $LOG2 2>&1 &
p2=$!
tail -f $LOG1 $LOG2 &
t=$!
ERR=0
wait $p1 $p2 || ERR=$?
cat $LOG1 $LOG2
kill -9 $t || true
wait || true

if [ $ERR -ne 0 ]; then
    exit $ERR
fi

make setup-gfarm-all
#make setup-gfperf
