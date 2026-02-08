# https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains
data "oci_identity_availability_domains" "ads" {
    compartment_id = var.compartment_id
}

locals {
    ad = var.availability_domain != "" ? var.availability_domain : data.oci_identity_availability_domains.ads.availability_domains[0].name
    manage_name = "gfmanage"
    gfmd_name_prefix = "gfmd"
    gfsd_name_prefix = "gfsd"
    gfclient_name_prefix = "gfclient"
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance
resource "oci_core_instance" "instance_manage" {
    display_name       = "${var.display_name_prefix}${local.manage_name}"
    create_vnic_details {
        # Use oci_dns_rrset
        #hostname_label = "${local.manage_name}.${var.domain}"
        #assign_private_dns_record = true
        assign_public_ip = true
        subnet_id = var.subnet_id
    }
    availability_domain = local.ad
    compartment_id = var.compartment_id
    shape = var.manage_shape != "" ? var.manage_shape : var.shape
    shape_config {
        ocpus                 = var.manage_ocpus
        memory_in_gbs         = var.manage_memory_in_gbs
    }
    source_details {
        source_id = var.manage_source_id != "" ? var.manage_source_id : var.source_id
        source_type = "image"
        boot_volume_size_in_gbs = var.manage_volume_size_in_gbs
        boot_volume_vpus_per_gb = var.manage_volume_vpus_per_gb
    }
    metadata = {
        name = local.manage_name
        ssh_authorized_keys = file(var.ssh_authorized_keys)
        user_data           = base64encode(data.template_file.cloud-init_manage.rendered)
    }
    preserve_boot_volume = false
}

resource "oci_core_instance" "instance_gfmd" {
    count = var.gfmd_num
    display_name       = "${var.display_name_prefix}${local.gfmd_name_prefix}${format("%02d", count.index + 1)}"
    create_vnic_details {
        #hostname_label     = "${local.gfmd_name_prefix}${format("%02d", count.index + 1)}.${var.domain}"
        #assign_private_dns_record = true
        assign_public_ip = true
        subnet_id = var.subnet_id
    }
    availability_domain = local.ad
    compartment_id = var.compartment_id
    shape = var.gfmd_shape != "" ? var.gfmd_shape : var.shape
    shape_config {
        ocpus                 = var.gfmd_ocpus
        memory_in_gbs         = var.gfmd_memory_in_gbs
    }
    source_details {
        source_id = var.gfmd_source_id != "" ? var.gfmd_source_id : var.source_id
        source_type = "image"
        boot_volume_size_in_gbs = var.gfmd_volume_size_in_gbs
        boot_volume_vpus_per_gb = var.gfmd_volume_vpus_per_gb
    }
    metadata = {
        name = "${local.gfmd_name_prefix}${format("%02d", count.index + 1)}"
        ssh_authorized_keys = file(var.ssh_authorized_keys)
        user_data           = base64encode(data.template_file.cloud-init_gfarm["gfmd"].rendered)
    }
    preserve_boot_volume = false
}

resource "oci_core_instance" "instance_gfsd" {
    count = var.gfsd_num
    display_name       = "${var.display_name_prefix}${local.gfsd_name_prefix}${format("%02d", count.index + 1)}"
    create_vnic_details {
        #hostname_label     = "${local.gfsd_name_prefix}${format("%02d", count.index + 1)}.${var.domain}"
        #assign_private_dns_record = true
        assign_public_ip = true
        subnet_id = var.subnet_id
    }
    availability_domain = local.ad
    compartment_id = var.compartment_id
    shape = var.gfsd_shape != "" ? var.gfsd_shape : var.shape
    shape_config {
        ocpus                 = var.gfsd_ocpus
        memory_in_gbs         = var.gfsd_memory_in_gbs
    }
    source_details {
        source_id = var.gfsd_source_id != "" ? var.gfsd_source_id : var.source_id
        source_type = "image"
        boot_volume_size_in_gbs = var.gfsd_volume_size_in_gbs
        boot_volume_vpus_per_gb = var.gfsd_volume_vpus_per_gb
    }
    metadata = {
        name = "${local.gfsd_name_prefix}${format("%02d", count.index + 1)}"
        ssh_authorized_keys = file(var.ssh_authorized_keys)
        user_data           = base64encode(data.template_file.cloud-init_gfarm["gfsd"].rendered)
    }
    preserve_boot_volume = false
}

resource "oci_core_instance" "instance_gfclient" {
    count = var.gfclient_num
    display_name       = "${var.display_name_prefix}${local.gfclient_name_prefix}${format("%02d", count.index + 1)}"
    create_vnic_details {
        #hostname_label     = "${local.gfclient_name_prefix}${format("%02d", count.index + 1)}.${var.domain}"
        #assign_private_dns_record = true
        assign_public_ip = true
        subnet_id = var.subnet_id
    }
    availability_domain = local.ad
    compartment_id = var.compartment_id
    shape = var.gfclient_shape != "" ? var.gfclient_shape : var.shape
    shape_config {
        ocpus                 = var.gfclient_ocpus
        memory_in_gbs         = var.gfclient_memory_in_gbs
    }
    source_details {
        source_id = var.gfclient_source_id != "" ? var.gfclient_source_id : var.source_id
        source_type = "image"
        boot_volume_size_in_gbs = var.gfclient_volume_size_in_gbs
        boot_volume_vpus_per_gb = var.gfclient_volume_vpus_per_gb
    }
    metadata = {
        name = "${local.gfclient_name_prefix}${format("%02d", count.index + 1)}"
        ssh_authorized_keys = file(var.ssh_authorized_keys)
        user_data           = base64encode(data.template_file.cloud-init_gfarm["gfclient"].rendered)
    }
    preserve_boot_volume = false
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_subnet
data "oci_core_subnet" "gfarm_subnet" {
    subnet_id = var.subnet_id
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/dns_zone
resource "oci_dns_zone" "gfarm_zone" {
    compartment_id = var.compartment_id
    name = var.domain
    zone_type = "PRIMARY"
    scope = "PRIVATE"
    view_id = var.view_id
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_dhcp_options
resource "oci_core_dhcp_options" "gfarm_dhcp_options" {
    compartment_id = var.compartment_id
    options {
        type = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
    }
    options {
        type = "SearchDomain"
        search_domain_names = [ var.domain ]
    }
    vcn_id = var.vcn_id
    display_name = "gfarm_dhcp"
}

locals {
    all_instances = concat(
                    [oci_core_instance.instance_manage],
                    oci_core_instance.instance_gfmd,
                    oci_core_instance.instance_gfsd,
                    oci_core_instance.instance_gfclient)
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/dns_rrset
resource "oci_dns_rrset" "gfarm_dns_record" {
    count = length(local.all_instances)
    domain = "${local.all_instances[count.index].metadata.name}.${var.domain}"
    rtype = "A"
    zone_name_or_id = oci_dns_zone.gfarm_zone.id
    # Deprecated; compartment is inferred from the zone and this argument is ignored. Will be removed in a future release.
    #compartment_id = var.compartment_id
    items {
        domain = "${local.all_instances[count.index].metadata.name}.${var.domain}"
        rdata = local.all_instances[count.index].private_ip
        rtype = "A"
        ttl = 3600
    }
    view_id = var.view_id
}
