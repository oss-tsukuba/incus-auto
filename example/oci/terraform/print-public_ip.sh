#!/bin/sh

terraform output -json | jq '.detail.value["oci-test"].public_ip' -r
