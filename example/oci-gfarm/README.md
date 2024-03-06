# Gfarm on OCI managed by terraform

## Start terraform client by incus-auto

#TODO make ssh-keygen

```
make init
make create
make  #TODO not in container
```

In incus container

#TODO "make oci-setup" target
- See and run `/SCRIPT/setup-oci-api.sh`
  - oepnssl genrsa
  - register the pubkey to https://cloud.oracle.com/identity/domains/my-profile/api-keys
  - ssh-keygen

## Ingress rule

- https://cloud.oracle.com/networking/vcns
- -> Select VCN
- -> Security Lists
- -> Default Security List or Create Security List
- -> Add Ingress Rules
  - source 10.0.0.0/8, TCP, All, All
    - インスタンス間通信を許可
  - (gfmd port) # TODO
  - (gfsd port) # TODO

## Init

```
cd /CONF
terraform init
```

## Plan

### terraform.tfvars

Create `terraform.tfvars` file to set parameters

- Sample: CONF/terraform.tfvars.sample
- Valiables: CONF/variables.tf
  - required variables
  - overridable variables

Confirm parameters

```
terraform plan
```

## Apply

```
terraform apply
...
  Enter a value: yes
```

## Setup Gfarm

```
exit  # from container

make ansible-inventory
make ansible-init
make set
```

## Destroy

```
terraform destroy
...
  Enter a value: yes

exit
make CLEAN
```

## TODO

- backup gfarm-terraform-oci
