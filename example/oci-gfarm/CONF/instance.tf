resource "oci_core_instance" "instance_gfmd" {
    count = var.gfmd_num
    display_name       = "${format("gfmd%02d", count.index + 1)}"
    availability_domain = var.availability_domain
    compartment_id = var.compartment_id
    shape = var.gfmd_shape
    shape_config {
        ocpus                 = var.gfmd_ocpus
        memory_in_gbs         = var.gfmd_mem
    }
    source_details {
        source_id = var.gfmd_source_id != "" ? var.gfmd_source_id : var.source_id
        source_type = "image"
        boot_volume_size_in_gbs = var.gfmd_disk
        boot_volume_vpus_per_gb = var.gfmd_disk_vpus
    }
    create_vnic_details {
        assign_public_ip = true
        subnet_id = var.subnet_id
    }
    metadata = {
        ssh_authorized_keys = file(var.ssh_authorized_keys)
        user_data           = base64encode(data.template_file.cloud-init_gfarm-ol9.rendered)
    }
    preserve_boot_volume = false
}

resource "oci_core_instance" "instance_gfsd" {
    count = var.gfsd_num
    display_name       = "${format("gfsd%02d", count.index + 1)}"
    availability_domain = var.availability_domain
    compartment_id = var.compartment_id
    shape = var.gfsd_shape
    shape_config {
        ocpus                 = var.gfsd_ocpus
        memory_in_gbs         = var.gfsd_mem
    }
    source_details {
        source_id = var.gfsd_source_id != "" ? var.gfsd_source_id : var.source_id
        source_type = "image"
        boot_volume_size_in_gbs = var.gfsd_disk
        boot_volume_vpus_per_gb = var.gfsd_disk_vpus
    }
    create_vnic_details {
        assign_public_ip = true
        subnet_id = var.subnet_id
    }
    metadata = {
        ssh_authorized_keys = file(var.ssh_authorized_keys)
        user_data           = base64encode(data.template_file.cloud-init_gfarm-ol9.rendered)
    }
    preserve_boot_volume = false
}
