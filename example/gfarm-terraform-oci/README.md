# Gfarm development environment on OCI managed by Terraform and Ansible

## Overview

- Step 1: Prepare files and configuration for OCI Web UI
- Step 2: Create a container to use Terraform by Incus or Docker
- Step 3: Create OCI (Oracle Cloud Infrastructure) instances by Terraform
- Step 4: Setup Gfarm environment on OCI instances by Ansible

### Step 1

In a host OS:

- Install `GNU make`
- Run the following commands:

```
make git-clone
make ssh-keygen
make ociapi-keygen
cat ./terraform/ociapi_public.pem
```

In the OCI Web Interface:

- Add API key
  - <https://cloud.oracle.com/identity/domains/my-profile/api-keys>
  - Paste the public key
- Create VCN and Create Subnet (if you need)
  - <https://cloud.oracle.com/networking/vcns>
  - Subnet example: 10.0.1.0/24
- Update Ingress Rules (in Security Lists for a subnet of VCN)
  - TCP Source=10.0.0.0/8 (for each OCI instances)
  - UDP Source=10.0.0.0/8 (for each OCI instances)
  - TCP Source=???.???.???.???/?? DestPort=22 (if you need) (for sshd)
  - TCP Source=???.???.???.???/?? DestPort=600 (if you need) (for gfsd)
  - UDP Source=???.???.???.???/?? DestPort=600 (if you need) (for gfsd)
  - TCP Source=???.???.???.???/?? DestPort=601 (if you need) (for gfmd)

In a host OS:

- Create `./terraform/terraform.tfvars` file to set parameters.
  - Find various OCIDs from the OCI Web Interface.
    - The URLs of each page are listed in `./terraform/variables.tf`.
  - Copy and paste various OCIDs.
  - Sample: `./terraform/terraform.tfvars.sample`
  - Defined Variables: `./terraform/variables.tf`
    - required variables
    - overridable variables

### Step 2 by Incus

In a host OS:

- See `../../README.md` to setup incus-auto
- Run the following commands:

```
make incus-init
make incus-create
make shell
```

### Step 2 by Docker (instead of Incus)

- (Perform Step 1)
- Install Docker
- To allow docker to run with user privileges
  - ex.: `sudo usermod -aG docker $USER`
- (In a host OS)
  - Install docker (with docker compose)
  - `make docker-build`
  - `make docker-up`
  - `make docker-shell` to login to a container
- (In a tf container)
  - (Perform Step 3)
  - (Perform Step 4)
- To destroy instances on OCI
  - `make terraform-destroy`
- To destroy docker container on a host OS
  - `make docker-down`
  - (Reusable files are not deleted)

### Step 3

In a tf container:

```
### Prompt: gfarmsys@tf:~$
cd ~/terraform
terraform init
terraform plan
terraform apply
  (Enter `yes`)
make update-ssh_known_hosts
  (Enter `yes`) (If it fails, check the Ingress rule)
make update-ssh_config
make update-ansible-inventory
make send-files
```

### Step 4

In a gfmanage instance on OCI:

```
### In a tf container
./ocissh gfmanage
### Prompt: gfarmsys@gfmanage:~$
cd ~/terraform/ansible/
sudo cloud-init status --wait
make ansible-init
  (Enter `yes`)
make ansible-gfarm-install
make ansible-gfarm-setup
```

### SSH to OCI

In a tf container:

- ./ocissh gfmanage
  - management host (Ansible, CA)
- ./ocissh gfclient01
- ./ocissh gfmd1
- ./ocissh gfsd01

### How to access Gfarm

#### In a gfclient01 on OCI (Oracle Linux)

```
[gfarmsys@gfclient01 ~]$ gfmdhost -l
+ master -     m siteA        gfmd1.example.org 601
+ slave  sync  c siteA        gfmd2.example.org 601
+ slave  async c siteB        gfmd3.example.org 601

[gfarmsys@gfclient01 ~]$ gfhost -lv
0.01/0.18/0.39 T aarch64 1 gfsd01.example.org 600 0(10.0.1.120)
0.01/0.30/0.57 T aarch64 1 gfsd02.example.org 600 0(10.0.1.146)
0.01/0.29/0.59 T aarch64 1 gfsd03.example.org 600 0(10.0.1.202)
0.03/0.36/0.63 T aarch64 1 gfsd04.example.org 600 0(10.0.1.43)
```

#### In a gfmanage on OCI (Ubuntu)

```
gfarmsys@gfmanage:~/terraform/ansible$ make gfarm-config-init
gfarmsys@gfmanage:~/terraform/ansible$ grid-proxy-init
gfarmsys@gfmanage:~/terraform/ansible$ gfhost -lv
```

#### In a tf container (access Gfarm via Internet) (Ubuntu)

```
gfarmsys@tf:~/terraform$ make gfarm-install
gfarmsys@tf:~/terraform$ make gfarm-config-fetch
gfarmsys@tf:~/terraform$ make update-etchosts-for-gfarm
gfarmsys@tf:~/terraform$ grid-proxy-init
gfarmsys@tf:~/terraform$ gfhost -lv
```

## Update RPM

- In a gfmanage on OCI
  - `make ansible-dnf-update`

## Update source code

- In a host OS
  - make git-pull
  - Edit `terraform/ansible/SRC/gfarm/*` files
- In a tf container in Incus
  - `make send-files`
  - or `make SYNC-files` to synchronize deleted files
- In a gfmanage on OCI
  - `make ansible-gfarm-install`
  - `make ansible-gfarm-restart`
  - `make gfarm-regress`

## Clear all Gfarm data

- In a gfmanage on OCI
  - `make ansible-gfarm-DESTROY`
    - unconfig-gfsd and unconfig-gfarm are called
  - `make ansible-gfarm-setup`

## Destroy all for Incus

- In a tf container in Incus
  - `make terraform-destroy` to delete OCI instances
  - NOTE: `terraform destroy` fails.
- In a host OS
  - `make CLEAN` to delete Incus container
- Reusable files are not deleted:
  - terraform/id_ecdsa
  - terraform/id_ecdsa.pub
  - terraform/ociapi_public.pem
  - terraform/ociapi_private.pem
  - terraform/terraform.tfvars
  - terraform/.terraform/

## TODO

- make backup
  - ../gfarm-terraform-oci.tar.gz
- Add hosts
- Add users
- Change authentication type
