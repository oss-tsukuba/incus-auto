#!/bin/bash
set -eu

CONFIG=$(./CONFIG.sh all)
IA="../../bin/incus-auto -c ${CONFIG}"

$IA "$@"
