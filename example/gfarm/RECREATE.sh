#!/bin/bash
set -eux

ARGS="$@"

IA="../../bin/incus-auto -f incus-auto.yaml,incus-auto.lustre.yaml,incus-auto.override.yaml"

$IA stop "${ARGS[@]}"
$IA delete "${ARGS[@]}"
$IA launch "${ARGS[@]}" -l debug

$IA ps
