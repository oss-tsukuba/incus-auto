#!/bin/bash
set -eux

ARGS="$@"

CONFIG=$(./CONFIG.sh all)
IA="../../bin/incus-auto -c ${CONFIG}"

$IA stop "${ARGS[@]}" -b
$IA delete "${ARGS[@]}" -b
$IA build "${ARGS[@]}" -l debug

$IA ps -b
