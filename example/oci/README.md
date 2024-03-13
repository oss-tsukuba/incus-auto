# Simple example of Terraform for OCI

## Usage

- (At host OS)
  - make REBUILD-ALL
  - make shell
- (At Incus container)
  - cd terraform
  - Edit `terraform/terraform.tfvars`
  - make ociapi-keygen
    - Add ociapi_public.pem
      - https://cloud.oracle.com/identity/domains/my-profile/api-keys
  - terraform init
  - terraform plan
  - terraform apply
  - make update-ssh_known_hsots
  - make ssh

## Destroy
- (At Incus container)
  - terraform destroy
- (At host OS)
  - make CLEAN
