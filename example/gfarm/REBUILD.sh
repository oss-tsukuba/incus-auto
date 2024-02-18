#!/bin/bash
set -eux

ARGS="$@"

CONFIG=$(./CONFIG.sh all)
IA="../../bin/incus-auto -c ${CONFIG}"

$IA stop "${ARGS[@]}" -b -f
$IA delete "${ARGS[@]}" -b
$IA build "${ARGS[@]}" -l debug

#$IA ps -b
echo DONE $0 "$@"
