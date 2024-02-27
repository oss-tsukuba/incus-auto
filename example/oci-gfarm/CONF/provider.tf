provider "oci" {
  tenancy_ocid = var.availability_domain
  user_ocid = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint = var.fingerprint
  region = var.region
}
