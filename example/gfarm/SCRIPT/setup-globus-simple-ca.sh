#!/bin/sh
set -eu

SUBJECT="cn=CA, ou=GfarmTest, o=Grid"
SETUP_TMP="${HOME}/gfarm-setup-tmp"

status=1
PROG=$(basename $0)
trap '[ $status = 0 ] && echo Done || echo NG: $PROG; exit $status' 0 1 2 15

[ -d /var/lib/globus/simple_ca/ ] && {
    status=0
    exit 0
}

# install and create simple ca
GSDIR=/etc/grid-security
sudo grid-ca-create -noint -subject "$SUBJECT" -nobuild
rm -f openssl_req.log
for f in $GSDIR/certificates/*.0
do
       B=$(basename $f)
       HASH=${B%.0}
       [ -f $GSDIR/certificates/grid-security.conf.$HASH ] && break
done
sudo grid-default-ca -ca $HASH > /dev/null

# copy CA cert
(cd $GSDIR/certificates && tar cf ${SETUP_TMP}/certs.tar $HASH.* *.$HASH)


status=0
