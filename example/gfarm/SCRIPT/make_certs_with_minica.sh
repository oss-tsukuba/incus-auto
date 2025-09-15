#!/bin/sh
set -eu

UPDATE=0
HOSTS=""
MINICADIR=/CONF/minica
CERTSDIR=/CONF/minica/certs

for arg in "$@"; do
    case "$arg" in
        --update) UPDATE=1 ;;
        *)        HOSTS="$HOSTS $arg" ;;
    esac
done
HOSTS="${HOSTS# }"  # trim leading space

remove_key() {
    HOST="$1"
    [ -d "$CERTSDIR/$HOST" ] && rm -f "$CERTSDIR/$HOST"/*.pem
}

if [ "$UPDATE" -eq 1 ]; then
    echo "Updating certificates..."
    rm -f $CERTSDIR/minica.pem $CERTSDIR/minica-key.pem
    for h in $HOSTS; do
        remove_key "$h"
    done
fi

MINICA="docker compose -f $MINICADIR/docker-compose.yaml run --rm -w /certs -v "$CERTSDIR:/certs" minica"

# FYI: minica auto-creates CA at first issuance
if [ -f certs/minica.pem ] && [ "$UPDATE" -ne 1 ]; then
    echo "Reusing existing CA ($CERTSDIR/minica.pem)"
else
    echo "Generating new CA on first issuance..."
fi

for h in $HOSTS; do
    if [ -d "$CERTSDIR/$h" ] && ls "$CERTSDIR/$h"/*.pem >/dev/null 2>&1; then
        echo "Skipping $h (already exists)"
        continue
    fi

    echo "Creating cert for $h..."
    # minica will create CA here if it doesn't exist
    $MINICA -domains "$h"

    # make CA readable if present
    if [ -f $CERTSDIR/minica.pem ]; then
        sudo chmod 644 $CERTSDIR/minica.pem
        [ -f $CERTSDIR/minica-key.pem ] && sudo chmod go-rwx $CERTSDIR/minica-key.pem  # keep key private
    fi

    sudo chmod go+rx "$CERTSDIR/$h"
    sudo chmod go+r "$CERTSDIR/$h"/*.pem
done

echo "Done."
