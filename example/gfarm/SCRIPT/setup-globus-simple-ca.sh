#!/bin/sh
set -eu

SUBJECT="cn=CA, ou=GfarmTest, o=Grid"
SETUP_TMP="${HOME}/gfarm-setup-tmp"

status=1
PROG=$(basename $0)
trap '[ $status = 0 ] && echo >&2 Done || echo >&2 NG: $PROG; exit $status' 0 1 2 15

ca_hash() {
    GSDIR=/etc/grid-security

    for f in $GSDIR/certificates/*.0
    do
        B=$(basename $f)
        H=${B%.0}
        [ -f $GSDIR/certificates/grid-security.conf.$H ] && break
    done
    echo $H
}

[ -d /var/lib/globus/simple_ca/ ] && {
    status=0
    ca_hash
    exit 0
}

# install and create simple ca
#TODO -pass "$(cat /CONF/ca-password.txt)"
sudo grid-ca-create -noint -subject "$SUBJECT" -nobuild
rm -f openssl_req.log
HASH=$(ca_hash)
sudo grid-default-ca -ca $HASH > /dev/null

echo $HASH
status=0
