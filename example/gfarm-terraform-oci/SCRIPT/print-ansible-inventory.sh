#!/bin/bash

set -eu
#set -x

cd /CONF

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
    echo $TFOUT | jq '.host.value.'${group}'["'${inst}'"].public_ip' -r
}

user() {
    local group=$1
    local inst=$2
    echo $TFOUT | jq '.host.value.'${group}'["'${inst}'"].user' -r
}

cat <<EOF
all:
  vars:
    known_hosts_file: /CONF/tmp-known_hosts
    ansible_ssh_private_key_file: /CONF/id_ecdsa
    ansible_ssh_common_args: "-o UserKnownHostsFile={{ known_hosts_file }}"
EOF

for group in $(group_list); do
    echo "${group}:"
    echo "  hosts:"
    for inst in $(instance_list $group); do
        echo "    ${inst}:"
        echo "      ansible_host: "$(public_ip $group $inst)
        echo "      ansible_user: "$(user $group $inst)
    done
done
