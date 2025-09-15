#!/bin/sh

set -xeu



WORKSPACE=/gfarm-http-gateway
CERTSPACE=/certs
CONFIG=$WORKSPACE/realm-config

sudo mkdir -p $CERTSPACE
/SCRIPT/make_certs_with_minica.sh gfarm-http-gateway.gfarm.test redis

sudo rsync -av /SRC/gfarm-http-gateway/ ${WORKSPACE}/
sudo mkdir -p ${WORKSPACE}/server/vendor/gfarm/
sudo rsync -av /SRC/gfarm/ ${WORKSPACE}/server/vendor/gfarm/

sudo rsync -av /CONF/gfarm-http-gateway/ ${WORKSPACE}/server
sudo rsync -av /CONF/minica/certs/ ${CERTSPACE}/
sudo chown -R gfarmsys $WORKSPACE
sudo chown -R gfarmsys $CERTSPACE

cd $WORKSPACE/server
docker compose down
docker compose up -d --build
