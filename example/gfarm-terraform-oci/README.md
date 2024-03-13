# Gfarm development environment on OCI managed by Terraform and Ansible

## Overview

- Step 1: Create container to use Terraform by incus-auto
- Step 2: Create OCI (Oracle Cloud) instances by Terraform
- Step 3: Setup Gfarm environment on OCI instances by Ansible

## Steps

### Step 1

At host OS:

```
make git-clone
make ssh-keygen
make incus-init
make incus-create
make shell
```

### Step 2

At tf container in Incus and OCI Web Interface:

```
### Prompt: gfarmsys@tf:~$
cd ~/terraform
make ociapi-keygen
cat ociapi_public.pem
```

- Add API key
  - <https://cloud.oracle.com/identity/domains/my-profile/api-keys>
  - Paste a public key
- Create VCN and Create Subnet (if you need)
  - <https://cloud.oracle.com/networking/vcns>
  - Subnet example: 10.0.1.0/24
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
cd ~/terraform/ansible/
sudo cloud-init status --wait
make ansible-init
make ansible-disable-selinux
make ansible-reboot
make ansible-gfarm-install
make ansible-gfarm-setup
```

### SSH to OCI

At tf container:

- ./ocissh gfmanage
  - management host (Ansible, CA)
- ./ocissh gfclient01
- ./ocissh gfmd1
- ./ocissh gfsd01

### Access Gfarm from client

#### At gfclient01 on OCI (Oracle Linux)

```
[gfarmsys@gfclient01 ~]$ gfmdhost -l
+ master -     m siteA        gfmd1.example.org 601
+ slave  async c siteA        gfmd2.example.org 601
+ slave  async c siteB        gfmd3.example.org 601

[gfarmsys@gfclient01 ~]$ gfhost -lv
0.01/0.18/0.39 T aarch64 1 gfsd01.example.org 600 0(10.0.1.120)
0.01/0.30/0.57 T aarch64 1 gfsd02.example.org 600 0(10.0.1.146)
0.01/0.29/0.59 T aarch64 1 gfsd03.example.org 600 0(10.0.1.202)
0.03/0.36/0.63 T aarch64 1 gfsd04.example.org 600 0(10.0.1.43)
```

#### At gfmanage on OCI (Ubuntu)

```
gfarmsys@gfmanage:~/terraform/ansible$ make gfarm-config-init
gfarmsys@gfmanage:~/terraform/ansible$ gfhost -lv
```

#### At tf container (access Gfarm via Internet) (Ubuntu)

```
make gfarm-install
make gfarm-config-fetch
make update-etchosts-for-gfarm
```

```
gfarmsys@tf:~/terraform$ gfhost -lv
```

## Update RPM

- At gfmanage on OCI
  - `make ansible-dnf-update`

## Update source code

- At host OS
  - make git-pull
  - Edit `terraform/ansible/SRC/gfarm/*` files
- At tf container in Incus
  - `make send-files`
  - or `make SYNC-files` to synchronize deleted files
- At gfmanage on OCI
  - `make ansible-gfarm-install`
  - `make ansible-gfarm-restart`
  - `make gfarm-regress`

## Clear all Gfarm data

- At gfmanage on OCI
  - `make ansible-gfarm-DESTROY`
    - unconfig-gfsd and unconfig-gfarm are called
  - `make ansible-gfarm-setup`

## Destroy all

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
- Add hosts
- Add users
- Change authentication type
