#!/bin/sh

set -eu
set -x

PULL=${1-} # "pull"

CLN()
{
    URL="$1"
    DIR="$2"
    BRANCH="$3"
    NAME=$(basename "${URL}" .git)

    if [ ! -d "${DIR}/${NAME}" ]; then
        (cd "${DIR}" && git clone -b "${BRANCH}" "${URL}")
    else
        if [ "${PULL}" = "pull" ]; then
            (cd "${DIR}/${NAME}" && git config pull.ff only && git pull)
        else
            (cd "${DIR}/${NAME}" && git checkout "${BRANCH}")
        fi
    fi
}

DIR=$(dirname $0)
cd "${DIR}/SRC"

CLN git@github.com:oss-tsukuba/gfarm.git                  .     2.8
CLN git@github.com:oss-tsukuba/gfarm2fs.git               gfarm master
CLN git@github.com:oss-tsukuba/jwt-logon.git              gfarm main
CLN git@github.com:oss-tsukuba/jwt-agent.git              gfarm main
CLN git@github.com:oss-tsukuba/cyrus-sasl-xoauth2-idp.git gfarm feature/keycloak
CLN git@github.com:scitokens/scitokens-cpp.git            gfarm master
CLN git@github.com:oss-tsukuba/jwt-server.git             gfarm main

CLN git@github.com:oss-tsukuba/lustre-release.git         .     hsm-posix-for-gfarm2fs

CLN git@github.com:oss-tsukuba/nextcloud-gfarm.git        .     master
CLN git@github.com:oss-tsukuba/gfarm-gridftp-dsi.git      .     master
