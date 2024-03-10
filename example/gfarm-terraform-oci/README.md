# Gfarm development environment on OCI managed by Terraform and Ansible

## Overview

- Step 1: Create container to use Terraform by incus-auto
- Step 2: Create OCI (Oracle Cloud) instances by Terraform
- Step 3: Setup Gfarm environment on OCI instances by Ansible

## Steps

### Step 1

At host OS:

```
make ssh-keygen
make incus-init
make incus-create
make shell
```

### Step 2

At tf container in Incus and OCI Web Interface:

```
### Prompt: admin@tf:~$
cd ~/terraform-oci
make ociapi-keygen
cat ociapi_public.pem
```

- Add API key
  - <https://cloud.oracle.com/identity/domains/my-profile/api-keys>
  - Paste a public key
- Create VCN and Create Subnet (if you need)
  - <https://cloud.oracle.com/networking/vcns>
- Update Ingress Rules (in Security Lists)
  - TCP Source=10.0.0.0/8 (for each OCI instances)
  - UCP Source=10.0.0.0/8 (for each OCI instances)
  - TCP Source=???.???.???.???/?? DestPort=22 (if you need) (for sshd)
  - TCP Source=???.???.???.???/?? DestPort=600 (if you need) (for gfsd)
  - UDP Source=???.???.???.???/?? DestPort=600 (if you need) (for gfsd)
  - TCP Source=???.???.???.???/?? DestPort=601 (if you need) (for gfmd)
- Create `terraform.tfvars` file to set parameters
  - Sample: `terraform.tfvars.sample`
  - Valiables: `variables.tf`
    - required variables
    - overridable variables

```
make terraform-init
make terraform-plan
make terrarorm-apply
make update-ssh_known_hosts
make update-ssh_config
make update-ansible-inventory
make send-files
```

### Step 3

At gfmanage instance on OCI:

```
### At tf container
./ocissh gfmanage
### Prompt: gfarmsys@gfmanage:~$
cd ~/terraform-oci/ansible/
make ansible-init
make ansible-ping
make ansible-gfarm-install
make ansible-gfarm-setup
```

### Gfarm client on OCI

from tf container

```
./ocissh gfclient01
```

```
[gfarmsys@gfclient01 ~]$ gfmdhost -l
+ master -     m siteA        gfmd1.example.org 601
+ slave  async c siteB        gfmd2.example.org 601
+ slave  async c siteB        gfmd3.example.org 601

[gfarmsys@gfclient01 ~]$ gfhost -lv
0.01/0.18/0.39 s aarch64 1 gfsd01.example.org 600 0(10.0.1.120)
0.01/0.30/0.57 s aarch64 1 gfsd02.example.org 600 0(10.0.1.146)
0.01/0.29/0.59 s aarch64 1 gfsd03.example.org 600 0(10.0.1.202)
0.03/0.36/0.63 s aarch64 1 gfsd04.example.org 600 0(10.0.1.43)
```

## Update source code

- At host OS
  - Edit `terraform/ansible/SRC/gfarm/*` files
- At tf container in Incus
  - `make send-files`
  - or `make SYNC-files` to synchronize deleted files
- At gfmanage on OCI
  - `make ansible-gfarm-install`
  - `make ansible-gfarm-restart`

## Clear all Gfarm data

- At gfmanage on OCI
  - `make ansible-gfarm-DESTROY`
  - `make ansible-gfarm-setup`

## Destroy

- At tf container in Incus
  - `make terraform-destroy`
- At gfmanage on OCI
  - `make CLEAN`
  - Reusable files (not deleted)
    - terraform/id_ecdsa
    - terraform/id_ecdsa.pub
    - terraform/ociapi_public.pem
    - terraform/ociapi_private.pem
    - terraform/terraform.tfvars
    - terraform/.terraform

## TODO

- make backup
  - ../gfarm-terraform-oci.tar.gz
- make TEST-ALL
- make ansible-gfarm-update-user
- Add hosts
- Add user
- Change authentication type
