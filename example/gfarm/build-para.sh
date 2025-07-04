#!/bin/sh

set -eux

LOG1=
LOG2=

clean() {
    [ -f "$LOG1" ] && rm -f $LOG1
    [ -f "$LOG2" ] && rm -f $LOG2
    return 0
}

mkt() {
    mktemp ${1}.tmp.XXXXXXXXXX.log
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
e1=0
e2=0
wait $p1 || e1=$?
wait $p2 || e2=$?
kill -9 $t || true
wait || true
echo "----- exit=$e1: $LOG1 ------"
cat $LOG1
echo "----- exit=$e2: $LOG2 ------"
cat $LOG2

if [ $e1 -ne 0 ]; then
    exit $e1
fi
if [ $e2 -ne 0 ]; then
    exit $e2
fi

make setup-gfarm-all
#make setup-gfperf
