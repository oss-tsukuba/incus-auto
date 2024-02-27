variable "gfmd_num" {
  description = "Number of gfmd"
  type        = number
  default     = 3
}

variable "gfsd_num" {
  description = "Number of gfsd"
  type        = number
  default     = 4
}

variable "gfclient_num" {
  description = "Number of gfarm client"
  type        = number
  default     = 1
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance#ocpus
variable "gfmd_ocpus" {
  description = "Number of OCPUs for gfmd"
  type        = number
  default     = 1
}

variable "gfsd_ocpus" {
  description = "Number of OCPUs for gfsd"
  type        = number
  default     = 1
}

variable "gfclient_ocpus" {
  description = "Number of OCPUs for gfclient"
  type        = number
  default     = 1
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance#memory_in_gbs
variable "gfmd_mem" {
  description = "memory_in_gbs for gfmd"
  type        = number
  default     = 1
}

variable "gfsd_mem" {
  description = "memory_in_gbs for gfsd"
  type        = number
  default     = 1
}

variable "gfclient_mem" {
  description = "memory_in_gbs for gfclient"
  type        = number
  default     = 1
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance#boot_volume_size_in_gbs
variable "gfmd_disk" {
  description = "boot_volume_size_in_gbs for gfmd"
  type        = number
  default     = 1
}

variable "gfsd_disk" {
  description = "boot_volume_size_in_gbs for gfsd"
  type        = number
  default     = 1
}

variable "gfclient_disk" {
  description = "boot_volume_size_in_gbs for gfclient"
  type        = number
  default     = 1
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance#boot_volume_vpus_per_gb
variable "gfmd_disk_vpus" {
  description = "boot_volume_vpus_per_gb for gfmd"
  type        = number
  default     = 10
}

variable "gfsd_disk_vpus" {
  description = "boot_volume_vpus_per_gb for gfsd"
  type        = number
  default     = 10
}

variable "gfclient_disk_vpus" {
  description = "boot_volume_vpus_per_gb for gfclient"
  type        = number
  default     = 10
}

# OCID from https://cloud.oracle.com/tenancy
variable "availability_domain" {
  description = "OCID of availability_domain (root compartment) from https://cloud.oracle.com/tenancy"
  type        = string
  # required
}

# OCID from https://cloud.oracle.com/tenancy
variable "compartment_id" {
  description = "OCID of compartment_id (root or child compartment) from https://cloud.oracle.com/tenancy"
  type        = string
  # use same OICD of availability_domain if it is not set
  default = ""
}

# OCID from https://cloud.oracle.com/networking/vcns
variable "subnet_id" {
  description = "OCID of subnet_id from https://cloud.oracle.com/networking/vcns"
  type        = string
  # required
}

# OCID from https://cloud.oracle.com/identity/domains/my-profile
variable "user_ocid" {
  description = "OCID of user_ocid from https://cloud.oracle.com/identity/domains/my-profile"
  type        = string
  # required
}

# private key from https://cloud.oracle.com/identity/domains/my-profile/api-keys
variable "private_key_path" {
  description = "path of generated private key for API from https://cloud.oracle.com/identity/domains/my-profile/api-keys"
  type        = string
  # required
}

# fingerprint from https://cloud.oracle.com/identity/domains/my-profile/api-keys
variable "fingerprint" {
  description = "fingerprint of API key from https://cloud.oracle.com/identity/domains/my-profile/api-keys"
  type        = string
  # required
}

# region ID from https://cloud.oracle.com/regions
variable "region" {
  description = "region ID from https://cloud.oracle.com/regions"
  type        = string
  # required
}
