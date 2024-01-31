#!/bin/bash

ARGS="$@"

IA=incus-auto

if [ ${ARGS[0]} = ALL ]; then
    $IA stop -a
    $IA delete -a
    $IA launch -a
else
    $IA stop "${ARGS[@]}"
    $IA delete "${ARGS[@]}"
    $IA launch "${ARGS[@]}"
fi

$IA ls
