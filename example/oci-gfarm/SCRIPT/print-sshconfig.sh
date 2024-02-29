#!/bin/bash

set -eu
#set -x

cd /CONF

#TODO /CONF/id_ecdsa
SSH_PRIVKEY=/CONF/sshkey

TFOUT=$(terraform output -json)

group_list() {
    echo $TFOUT | jq '.host.value | to_entries[] | .key' -r
}

instance_list() {
    local group=$1
    echo $TFOUT | jq '.host.value.'${group}' | to_entries[] | .key' -r
}

public_ip() {
    local group=$1
    local inst=$2
    echo $TFOUT | jq .host.value.${group}.${inst}.public_ip -r
}

user() {
    local group=$1
    local inst=$2
    echo $TFOUT | jq .host.value.${group}.${inst}.user -r
}

cat <<EOF
UserKnownHostsFile /CONF/tmp-known_hosts

EOF

for group in $(group_list); do
    for inst in $(instance_list $group); do
        public_ip=$(public_ip $group $inst)
        user=$(user $group $inst)
        cat <<EOF
Host ${inst}
HostName ${public_ip}
User ${user}
IdentityFile ${SSH_PRIVKEY}

EOF
    done
done
