#!/bin/bash
set -eux

ARGS="$@"
PROJECT="gfarm"

IA=incus-auto

if [ ${ARGS[0]} = ALL ]; then
    $IA stop -a -b
    $IA delete -a -b
    $IA build -a -b
else
    $IA stop "${ARGS[@]}" -b
    $IA delete "${ARGS[@]}" -b
    $IA build "${ARGS[@]}" -l debug
fi

$IA ls
