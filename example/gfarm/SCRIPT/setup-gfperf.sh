#!/bin/bash

# for gfclient1 container

source /SCRIPT/lib.sh

GFARM_PREFIX=/usr/local
DOCUMENT_ROOT=/var/www/html
GFPERF_WEB_DIR=${DOCUMENT_ROOT}/gfperf
GFPERF_DB_DIR=/var/www/gfperf_db
GFARM2FS_MNTDIR=/mnt/_gfperf
GFARM_WORKDIR=/home/_gfperf

SUDO apt-get install -y \
     apache2 \
     ruby \
     ruby-sqlite3 \
     php \
     php-sqlite3 \
     gnuplot

SUDO mkdir -p ${GFPERF_WEB_DIR}/
SUDO cp -f ${GFARM_PREFIX}/share/gfarm/gfperf-web/* ${GFPERF_WEB_DIR}/

SUDO cp -f /CONF/gfperf-config.php ${GFPERF_WEB_DIR}/config.php

SUDO chown -R www-data $DOCUMENT_ROOT
SUDO mkdir -p $GFPERF_DB_DIR
SUDO chown www-data:$SYS_USER $GFPERF_DB_DIR
SUDO chmod 770 $GFPERF_DB_DIR

SUDO mkdir -p $GFARM2FS_MNTDIR
SUDO chown $SYS_USER:$SYS_USER $GFARM2FS_MNTDIR

gfmkdir -p $GFARM_WORKDIR

# test
gfperf.rb /CONF/gfperf-simple.yml

tmpfile=$(mktemp)
crontab -l > $tmpfile || true  # may be empty

if ! grep -q gfperf.rb $tmpfile; then
    cat <<EOF >> $tmpfile
#0 0 * * * gfperf.rb /CONF/gfperf-simple.yml
EOF
fi

cat $tmpfile | crontab -
rm -rf $tmpfile


IP=$(MYIP)
echo "URL: http://gfclient1/gfperf/ via squid (http proxy: http://${IP}:3128)"
