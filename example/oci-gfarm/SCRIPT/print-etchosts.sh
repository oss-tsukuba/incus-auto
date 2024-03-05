#!/bin/bash

set -eu
#set -x

cd /CONF

TFOUT=$(terraform output -json)

instance_list() {
    echo $TFOUT | jq '.host.value | to_entries[] | .key + "[\"" + (.value | keys[]) + "\"]"' -r
}

public_ip() {
    local inst=$1
    echo $TFOUT | jq '.host.value.'${inst}'.public_ip' -r
}

for inst in $(instance_list); do
    # ex. inst=manage["manage.example.org"]
    group=$(echo $inst | cut -d\[ -f 1)
    name=$(echo $inst | sed 's/'$group'\["//; s/"\]//')
    shortname=$(echo $name | cut -d. -f 1)
    printf "%-16s   %s %s\n" $(public_ip $inst) $name $shortname
done
