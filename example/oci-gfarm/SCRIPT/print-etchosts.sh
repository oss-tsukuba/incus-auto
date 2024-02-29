#!/bin/bash

set -eu
#set -x

cd /CONF

TFOUT=$(terraform output -json)

instance_list() {
    echo $TFOUT | jq '.host.value | to_entries[] | .key + "." + (.value | keys[])' -r
}

public_ip() {
    local inst=$1
    echo $TFOUT | jq .host.value.${inst}.public_ip -r
}

for inst in $(instance_list); do
    # ex. inst=gfmd.gfmd01
    name=$(echo $inst | cut -d. -f 2)
    printf "%-16s %s\n" $(public_ip $inst) $name
done
