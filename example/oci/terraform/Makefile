ssh:
	ssh -o 'UserKnownHostsFile ./tmp-known_hosts' -o 'ServerAliveInterval 60' -o 'IdentityFile ./id_ecdsa' opc@`bash ./print-public_ip.sh`

ociapi-keygen:
	bash ./setup-oci-api.sh

print-public_ip:
	bash ./print-public_ip.sh
update-ssh_known_hsots:
	ssh-keyscan `bash ./print-public_ip.sh` > ./tmp-known_hosts
