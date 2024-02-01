#!/bin/bash

set -eux

cd SRC

if [ ! -d gfarm ]; then
    git clone git@github.com:oss-tsukuba/gfarm.git
    cd gfarm
else
    cd gfarm
    git pull
fi
GFARM_DIR=$(pwd)

LIST="
git@github.com:oss-tsukuba/gfarm2fs.git
git@github.com:oss-tsukuba/jwt-logon.git
git@github.com:oss-tsukuba/jwt-agent.git
git@github.com:oss-tsukuba/cyrus-sasl-xoauth2-idp.git
git@github.com:scitokens/scitokens-cpp.git
git@github.com:oss-tsukuba/jwt-server.git
"

for url in $LIST; do
    name=$(basename $url)
    name=${name%.git}
    cd "$GFARM_DIR"
    if [ ! -d $name ]; then
        git clone $url
        cd $name
    else
        cd $name
        git pull
    fi
done
