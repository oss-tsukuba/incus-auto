variable "timezone" {
  description = "Timezone"
  type        = string
  default     = "Asia/Tokyo"
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
  default     = 2
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
  default     = 4
}

variable "gfsd_mem" {
  description = "memory_in_gbs for gfsd"
  type        = number
  default     = 2
}

variable "gfclient_mem" {
  description = "memory_in_gbs for gfclient"
  type        = number
  default     = 2
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance#boot_volume_size_in_gbs
variable "gfmd_disk" {
  description = "boot_volume_size_in_gbs for gfmd"
  type        = number
  default     = null
}

variable "gfsd_disk" {
  description = "boot_volume_size_in_gbs for gfsd"
  type        = number
  default     = null
}

variable "gfclient_disk" {
  description = "boot_volume_size_in_gbs for gfclient"
  type        = number
  default     = null
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

# https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm#flexible
variable "gfmd_shape" {
  description = "from https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm#flexible"
  type        = string
  # ARM processor
  default     = "VM.Standard.A1.Flex"
}

variable "gfsd_shape" {
  description = "from https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm#flexible"
  type        = string
  # ARM processor
  default     = "VM.Standard.A1.Flex"
}

variable "gfclient_shape" {
  description = "from https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm#flexible"
  type        = string
  # ARM processor
  default     = "VM.Standard.A1.Flex"
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

# overridable
variable "manage_source_id" {
  description = "override source_id"
  type        = string
  # Canonical-Ubuntu-22.04-aarch64-2024.01.12-0
  # https://docs.oracle.com/en-us/iaas/images/image/75c27c16-e357-44a6-8003-6da76f2f139d/
  # ap-tokyo-1
  default     = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaavo7svqug5ulgyw4zq4mcfn2glflxxtaahuyoejf4purtgu2urk4q"
}

# overridable
variable "gfmd_source_id" {
  description = "override source_id"
  type        = string
  default     = ""
}

# overridable
variable "gfsd_source_id" {
  description = "override source_id"
  type        = string
  default     = ""
}

# overridable
variable "gfclient_source_id" {
  description = "override source_id"
  type        = string
  default     = ""
}

# Oracle Linux, etc.: opc
# Ubuntu: ubuntu
variable "gfmd_admin_user" {
  description = "admin username: (ex. opc, ubuntu) "
  type        = string
  default     = "opc"
}

variable "gfsd_admin_user" {
  description = "admin username: (ex. opc, ubuntu) "
  type        = string
  default     = "opc"
}

variable "gfclient_admin_user" {
  description = "admin username: (ex. opc, ubuntu) "
  type        = string
  default     = "opc"
}

variable "manage_admin_user" {
  description = "admin username: (ex. opc, ubuntu) "
  type        = string
  default     = "ubuntu"
}

# Availability domain from https://cloud.oracle.com/compute/instances/create
# and Cancel (not create instance on Web UI)
# ex. pIoR:AP-TOKYO-1-AD-1
variable "availability_domain" {
  description = "Availability domain from https://cloud.oracle.com/compute/instances/create"
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

variable "ssh_authorized_keys" {
  description = "path of a authorized_keys-file (ssh public keys) to login instances"
  type        = string
  # required
}
