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

#####################################

variable "timezone" {
  description = "Timezone"
  type        = string
  default     = "Asia/Tokyo"
}

variable "domain" {
  description = "Domain name"
  type        = string
  default     = "example.org"
}

variable "admin_user" {
  description = "Admin user"
  type        = string
  default     = "gfarmsys"
}

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
variable "gfmd_memory_in_gbs" {
  description = "memory_in_gbs for gfmd"
  type        = number
  default     = 4
}

variable "gfsd_memory_in_gbs" {
  description = "memory_in_gbs for gfsd"
  type        = number
  default     = 3
}

variable "gfclient_memory_in_gbs" {
  description = "memory_in_gbs for gfclient"
  type        = number
  default     = 3
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance#boot_volume_size_in_gbs
variable "gfmd_volume_size_in_gbs" {
  description = "boot_volume_size_in_gbs for gfmd"
  type        = number
  default     = null
}

variable "gfsd_volume_size_in_gbs" {
  description = "boot_volume_size_in_gbs for gfsd"
  type        = number
  default     = null
}

variable "gfclient_volume_size_in_gbs" {
  description = "boot_volume_size_in_gbs for gfclient"
  type        = number
  default     = null
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance#boot_volume_vpus_per_gb
variable "gfmd_volume_vpus_per_gb" {
  description = "boot_volume_vpus_per_gb for gfmd"
  type        = number
  default     = 10
}

variable "gfsd_volume_vpus_per_gb" {
  description = "boot_volume_vpus_per_gb for gfsd"
  type        = number
  default     = 10
}

variable "gfclient_volume_vpus_per_gb" {
  description = "boot_volume_vpus_per_gb for gfclient"
  type        = number
  default     = 10
}

variable "oracle_linux_version" {
    description = "Oracle Linux Version (OL8, OL9)"
    type        = string
    default     = "OL9"
}

# https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm
variable "shape" {
  description = "from https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm#flexible"
  type        = string
  # ARM processor
  default     = "VM.Standard.A1.Flex"
}

# individually overridable
variable "gfmd_shape" {
  description = "from https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm#flexible"
  type        = string
  # ARM processor
  default     = ""
}

# individually overridable
variable "gfsd_shape" {
  description = "from https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm#flexible"
  type        = string
  # ARM processor
  default     = ""
}

# individually overridable
variable "gfclient_shape" {
  description = "from https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm#flexible"
  type        = string
  # ARM processor
  default     = ""
}

variable "manage_shape" {
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

# individually overridable
variable "manage_source_id" {
  description = "override source_id"
  type        = string
  # Canonical-Ubuntu-22.04-aarch64-2024.01.12-0
  # https://docs.oracle.com/en-us/iaas/images/image/75c27c16-e357-44a6-8003-6da76f2f139d/
  # ap-tokyo-1
  default     = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaavo7svqug5ulgyw4zq4mcfn2glflxxtaahuyoejf4purtgu2urk4q"
}

# individually overridable
variable "gfmd_source_id" {
  description = "override source_id"
  type        = string
  default     = ""
}

# individually overridable
variable "gfsd_source_id" {
  description = "override source_id"
  type        = string
  default     = ""
}

# individually overridable
variable "gfclient_source_id" {
  description = "override source_id"
  type        = string
  default     = ""
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
variable "vcn_id" {
  description = "OCID of VCN from https://cloud.oracle.com/networking/vcns"
  type        = string
  # required
}

# OCID of subnet from https://cloud.oracle.com/networking/vcns
variable "subnet_id" {
  description = "OCID of subnet from https://cloud.oracle.com/networking/vcns"
  type        = string
  # required
}

# OCID from https://cloud.oracle.com/dns/views
variable "view_id" {
  description = "OCID from https://cloud.oracle.com/dns/views"
  type        = string
  # required
}

variable "ssh_authorized_keys" {
  description = "path of a authorized_keys-file (ssh public keys) to login instances"
  type        = string
  # required
}
