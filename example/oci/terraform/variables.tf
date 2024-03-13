# OCID of availability_domain (root compartment) from https://cloud.oracle.com/tenancy
variable "tenancy_ocid" {
  description = "tenancy_ocid"
  type        = string
}

# OCID of user_ocid from https://cloud.oracle.com/identity/domains/my-profile
variable "user_ocid" {
  description = "user_ocid"
  type        = string
}

# path of generated private key for API from https://cloud.oracle.com/identity/domains/my-profile/api-keys
variable "private_key_path" {
  description = "private_key_path"
  type        = string
}

# fingerprint of API key from https://cloud.oracle.com/identity/domains/my-profile/api-keys
variable "fingerprint" {
  description = "fingerprint of API key"
  type        = string
}

# region ID from https://cloud.oracle.com/regions
variable "region" {
  description = "region ID from https://cloud.oracle.com/regions"
  type        = string
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance#ocpus
variable "ocpus" {
  description = "Number of OCPUs"
  type        = number
  default     = 1
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance#memory_in_gbs
variable "memory" {
  description = "memory_in_gbs"
  type        = number
  default     = 4
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance#boot_volume_size_in_gbs
variable "boot_volume_size_in_gbs" {
  description = "boot_volume_size_in_gbs"
  type        = number
  default     = null
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance#boot_volume_vpus_per_gb
variable "boot_volume_vpus_per_gb" {
  description = "boot_volume_vpus_per_gb"
  type        = number
  default     = 10
}

# https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm
variable "shape" {
  description = "from https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm#flexible"
  type        = string
  # ARM processor
  default     = "VM.Standard.A1.Flex"
}

# from https://docs.oracle.com/en-us/iaas/images/
# default source_id for all instance
variable "source_id" {
  description = "from https://docs.oracle.com/en-us/iaas/images/"
  type        = string

  # for ARM processor
  # Oracle-Linux-8.9-aarch64-2024.01.26-0
  # https://docs.oracle.com/iaas/images/image/b2b2f4cb-515b-49e0-b08c-1fb07be8da5d/
  # ap-tokyo-1
  # default     = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaaeu6r3tmcbrhc2msuvchzbg2zksa5ypuarj2r75v7tnhonq6ih3oq"

  # Oracle-Linux-9.3-aarch64-2024.01.26-0
  # https://docs.oracle.com/en-us/iaas/images/image/374162b8-944e-4c4e-9587-e055f65e6ead/
  # ap-tokyo-1
  default     = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaakoj4yfoziwsrfzxk7n5aq2qp3habdji67366mon22rkni6fxd3bq"
}

# Availability domain from https://cloud.oracle.com/compute/instances/create
# and Cancel (not create instance on Web UI)
# ex. pIoR:AP-TOKYO-1-AD-1
# overridable
variable "availability_domain" {
  description = "Availability domain from https://cloud.oracle.com/compute/instances/create"
  type        = string
  default     = ""
}

# OCID from https://cloud.oracle.com/tenancy
variable "compartment_id" {
  description = "OCID of compartment_id (root or child compartment) from https://cloud.oracle.com/tenancy"
  type        = string
  # use same OICD of availability_domain if it is not set
  default = ""
}

# OCID of VCN from https://cloud.oracle.com/networking/vcns
# variable "vcn_id" {
#   description = "OCID of VCN from https://cloud.oracle.com/networking/vcns"
#   type        = string
#   # required
# }

# OCID of subnet from https://cloud.oracle.com/networking/vcns
variable "subnet_id" {
  description = "OCID of subnet from https://cloud.oracle.com/networking/vcns"
  type        = string
  # required
}

# OCID from https://cloud.oracle.com/dns/views
# variable "view_id" {
#   description = "OCID from https://cloud.oracle.com/dns/views"
#   type        = string
#   # required
# }

variable "ssh_authorized_keys" {
  description = "path of a authorized_keys-file (ssh public keys) to login instances"
  type        = string
  # required
}
