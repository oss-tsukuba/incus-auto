#!/bin/bash

set -eu
set -x

FILE=/etc/hosts
ORIG=${FILE}.orig

if [ -f $ORIG ]; then
    sudo cp -f $ORIG $FILE
else
    sudo cp -f $FILE $ORIG
fi

bash ./print-etchosts.sh | sudo tee -a $FILE
