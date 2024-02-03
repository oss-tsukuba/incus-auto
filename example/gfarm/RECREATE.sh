#!/bin/bash
set -eux

ARGS="$@"

IA=incus-auto

if [ ${ARGS[0]} = ALL ]; then
    $IA stop -a
    $IA delete -a
    $IA launch -a
else
    $IA stop "${ARGS[@]}"
    $IA delete "${ARGS[@]}"
    $IA launch "${ARGS[@]}" -l debug
fi

$IA update-etchosts -a
$IA exec manage -- bash -x /SCRIPT/setup-ansible.sh
$IA ls
