#!/bin/bash
set -eux

ARGS="$@"

CONFIG=$(./CONFIG.sh all)
IA="../../bin/incus-auto -c ${CONFIG}"

$IA stop -f "${ARGS[@]}"
$IA delete "${ARGS[@]}"
$IA launch "${ARGS[@]}" -l debug

$IA ps
