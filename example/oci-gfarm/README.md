# Gfarm for OCI managed by terraform

## Start terraform client by incus-auto

```
make init
make create
make
```

In incus container

TODO /SCRIPT/setup-oci-api.sh
- oepnssl genrsa
- register the pubkey to https://cloud.oracle.com/identity/domains/my-profile/api-keys
- ssh-keygen

```
cd /CONF
terraform init
```

## Required parameters

Sample: CONF/terraform.tfvars.sample
Valiables(overridable): CONF/variables.tf

- 


## terraform plan

### Enter parameters interactively if -var-file is not specified

```
terraform plan
```

### Set parameters in *.tfvars file

```
terraform plan -var-file=ANY_FILENAME.tfvars
```

## terraform apply

## terraform destroy
