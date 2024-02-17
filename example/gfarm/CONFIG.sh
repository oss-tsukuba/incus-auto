#!/bin/sh

TARGET="$1"

BASE=incus-auto.yaml
GFARM=incus-auto.gfarm.yaml,incus-auto.gfarm.override.yaml
LUSTRE=incus-auto.lustre.yaml,incus-auto.lustre.override.yaml
OVERRIDE=incus-auto.override.yaml

case $TARGET in
    gfarm)
        echo ${BASE},${GFARM},${OVERRIDE}
        ;;
    lustre)
        echo ${BASE},${LUSTRE},${OVERRIDE}
        ;;
    all)
        echo ${BASE},${GFARM},${LUSTRE},${OVERRIDE}
        ;;
    *)
        echo >&2 "unknown target: $TARGET"
        exit 1
        ;;
esac
