#!/bin/sh

set -xeu

WORKSPACE=/keycloak
CERTSPACE=/certs
CONFIG=$WORKSPACE/realm-config

sudo mkdir -p $CERTSPACE
/SCRIPT/make_certs_with_minica.sh keycloak.gfarm.test

sudo rsync -av /CONF/keycloak/ ${WORKSPACE}/
sudo rsync -av /CONF/minica/certs/ ${CERTSPACE}/
sudo chown -R gfarmsys $WORKSPACE
sudo chown -R gfarmsys $CERTSPACE

# git clone -b 2.8 https://github.com/oss-tsukuba/gfarm.git

echo "127.0.0.1   keycloak.gfarm.test" | sudo tee -a /etc/hosts

cd $WORKSPACE
docker compose up -d