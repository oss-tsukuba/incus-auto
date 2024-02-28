# Gfarm for OCI managed by terraform

## Start terraform client by incus-auto

```
make init
make create
make
```

In incus container

- See and run `/SCRIPT/setup-oci-api.sh`
  - oepnssl genrsa
  - register the pubkey to https://cloud.oracle.com/identity/domains/my-profile/api-keys
  - ssh-keygen

## Init

Create `/CONF/provider.tf`

```
cd /CONF
cp provider.tf.sample provider.tf
vi provider.tf
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
```

## Destroy

```
terraform destroy
```
