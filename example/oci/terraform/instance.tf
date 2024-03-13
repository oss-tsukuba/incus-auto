# https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains
data "oci_identity_availability_domains" "ads" {
    compartment_id = var.compartment_id
}

locals {
    ad = var.availability_domain != "" ? var.availability_domain : data.oci_identity_availability_domains.ads.availability_domains[0].name
}

resource "oci_core_instance" "instance_test" {
    # Required
    availability_domain = local.ad
    compartment_id = var.compartment_id
    shape = var.shape
    source_details {
        source_id = var.source_id
        source_type = "image"
        boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
        boot_volume_vpus_per_gb = var.boot_volume_vpus_per_gb
    }
    # for flex type
    shape_config {
        ocpus                 = var.ocpus
        memory_in_gbs         = var.memory
    }

    # Optional
    display_name = "oci-test"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = var.subnet_id
    }
    metadata = {
        ssh_authorized_keys = file(var.ssh_authorized_keys)
    }
    preserve_boot_volume = false
}
