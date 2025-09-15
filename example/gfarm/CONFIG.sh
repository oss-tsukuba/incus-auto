#!/bin/sh

TARGET="$1"

BASE=incus-auto.yaml
GFARM=incus-auto.gfarm.yaml,incus-auto.gfarm.override.yaml
KEYCLOAK=incus-auto.keycloak.yaml,incus-auto.keycloak.override.yaml
GFHG=incus-auto.gfarm-http-gateway.yaml,incus-auto.gfarm-http-gateway.override.yaml
LUSTRE=incus-auto.lustre.yaml,incus-auto.lustre.override.yaml
OVERRIDE=incus-auto.override.yaml

case $TARGET in
    gfarm)
        echo ${BASE},${GFARM},${OVERRIDE}
        ;;
    lustre)
        echo ${BASE},${LUSTRE},${OVERRIDE}
        ;;
    keycloak)
        echo ${BASE},${KEYCLOAK},${OVERRIDE}
        ;;
    gfhg)
        echo ${BASE},${GFHG},${OVERRIDE}
        ;;
    gfhgall)
        echo ${BASE},${GFARM},${KEYCLOAK},${GFHG},${OVERRIDE}
        ;;
    all)
        echo ${BASE},${GFARM},${LUSTRE},${KEYCLOAK},${GFHG},${OVERRIDE}
        ;;
    *)
        echo >&2 "unknown target: $TARGET"
        exit 1
        ;;
esac
