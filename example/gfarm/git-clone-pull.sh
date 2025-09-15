#!/bin/sh

set -eu
set -x

PULL=${1-} # "pull"

GITURL_GFARM_SSH=git@github.com:oss-tsukuba
GITURL_GFARM_HTTPS=https://github.com/oss-tsukuba

GITURL_SCITOKENS=https://github.com/scitokens

#GITURL_GFARM=$GITURL_GFARM_SSH
GITURL_GFARM=$GITURL_GFARM_HTTPS

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

CLN ${GITURL_GFARM}/gfarm.git                  .     2.8
CLN ${GITURL_GFARM}/gfarm2fs.git               gfarm master
CLN ${GITURL_GFARM}/jwt-logon.git              gfarm main
CLN ${GITURL_GFARM}/jwt-agent.git              gfarm main
CLN ${GITURL_GFARM}/cyrus-sasl-xoauth2-idp.git gfarm feature/keycloak
CLN ${GITURL_GFARM}/jwt-server.git             gfarm main
CLN ${GITURL_SCITOKENS}/scitokens-cpp.git      gfarm master

CLN ${GITURL_GFARM}/lustre-release.git         .     hsm-posix-for-gfarm2fs

CLN ${GITURL_GFARM}/nextcloud-gfarm.git        .     master
CLN ${GITURL_GFARM}/gfarm-gridftp-dsi.git      .     master

CLN ${GITURL_GFARM}/gfarm-http-gateway.git     .     main