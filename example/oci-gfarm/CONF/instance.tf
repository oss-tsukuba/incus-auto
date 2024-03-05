# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance

resource "oci_core_instance" "instance_manage" {
    display_name       = "manage"
    availability_domain = var.availability_domain
    compartment_id = var.compartment_id
    shape = var.manage_shape
    shape_config {
        ocpus                 = 1
        memory_in_gbs         = 2
    }
    source_details {
        source_id = var.manage_source_id
        source_type = "image"
        boot_volume_size_in_gbs = null  # default
        boot_volume_vpus_per_gb = null  # default
    }
    create_vnic_details {
        assign_public_ip = true
        subnet_id = var.subnet_id
    }
    metadata = {
        ssh_authorized_keys = file(var.ssh_authorized_keys)
        user_data           = base64encode(data.template_file.cloud-init_manage.rendered)
    }
    preserve_boot_volume = false
}

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

resource "oci_core_instance" "instance_gfclient" {
    count = var.gfclient_num
    display_name       = "${format("gfclient%02d", count.index + 1)}"
    availability_domain = var.availability_domain
    compartment_id = var.compartment_id
    shape = var.gfclient_shape
    shape_config {
        ocpus                 = var.gfclient_ocpus
        memory_in_gbs         = var.gfclient_mem
    }
    source_details {
        source_id = var.gfclient_source_id != "" ? var.gfclient_source_id : var.source_id
        source_type = "image"
        boot_volume_size_in_gbs = var.gfclient_disk
        boot_volume_vpus_per_gb = var.gfclient_disk_vpus
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

# Deprecated. Use oci_dns_rrset instead.
# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/dns_record
# resource "oci_dns_record" "gfsd_dns_record" {
#     count = length(oci_core_instance.instance_gfsd)
#
#     zone_name_or_id = oci_dns_zone.gfarm_zone.id
#     domain = "${oci_core_instance.instance_gfsd[count.index].display_name}.${var.domain}"
#     rtype = "A"
#
#     compartment_id = var.compartment_id
#     rdata = oci_core_instance.instance_gfsd[count.index].private_ip
# }

# resource "terraform_data" "all_instance" {
#     depends_on = [
#       oci_core_instance.instance_manage,
#       oci_core_instance.instance_gfmd,
#       oci_core_instance.instance_gfsd,
#       oci_core_instance.instance_gfclient,
#     ]
#     input = concat([oci_core_instance.instance_manage],
#                    oci_core_instance.instance_gfmd,
#                    oci_core_instance.instance_gfsd,
#                    oci_core_instance.instance_gfclient)
# }

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/dns_rrset
#
# dirty plan...
# resource "oci_dns_rrset" "gfarm_dns_record" {
#     count = length(terraform_data.all_instance.output)
#     domain = "${terraform_data.all_instance.output[count.index].display_name}.${var.domain}"
#     rtype = "A"
#     zone_name_or_id = oci_dns_zone.gfarm_zone.id
#     compartment_id = var.compartment_id
#     items {
#         domain = "${terraform_data.all_instance.output[count.index].display_name}.${var.domain}"
#         rdata = terraform_data.all_instance.output[count.index].private_ip
#         rtype = "A"
#         ttl = 3600
#     }
#     view_id = var.view_id
# }

resource "oci_dns_rrset" "manage_dns_record" {
    domain = "${oci_core_instance.instance_manage.display_name}.${var.domain}"
    rtype = "A"
    zone_name_or_id = oci_dns_zone.gfarm_zone.id
    compartment_id = var.compartment_id
    items {
        domain = "${oci_core_instance.instance_manage.display_name}.${var.domain}"
        rdata = oci_core_instance.instance_manage.private_ip
        rtype = "A"
        ttl = 3600
    }
    view_id = var.view_id
}

resource "oci_dns_rrset" "gfmd_dns_record" {
    count = length(oci_core_instance.instance_gfmd)
    domain = "${oci_core_instance.instance_gfmd[count.index].display_name}.${var.domain}"
    rtype = "A"
    zone_name_or_id = oci_dns_zone.gfarm_zone.id
    compartment_id = var.compartment_id
    items {
        domain = "${oci_core_instance.instance_gfmd[count.index].display_name}.${var.domain}"
        rdata = oci_core_instance.instance_gfmd[count.index].private_ip
        rtype = "A"
        ttl = 3600
    }
    view_id = var.view_id
}

resource "oci_dns_rrset" "gfsd_dns_record" {
    count = length(oci_core_instance.instance_gfsd)
    domain = "${oci_core_instance.instance_gfsd[count.index].display_name}.${var.domain}"
    rtype = "A"
    zone_name_or_id = oci_dns_zone.gfarm_zone.id
    compartment_id = var.compartment_id
    items {
        domain = "${oci_core_instance.instance_gfsd[count.index].display_name}.${var.domain}"
        rdata = oci_core_instance.instance_gfsd[count.index].private_ip
        rtype = "A"
        ttl = 3600
    }
    view_id = var.view_id
}

resource "oci_dns_rrset" "gfclient_dns_record" {
    count = length(oci_core_instance.instance_gfclient)
    domain = "${oci_core_instance.instance_gfclient[count.index].display_name}.${var.domain}"
    rtype = "A"
    zone_name_or_id = oci_dns_zone.gfarm_zone.id
    compartment_id = var.compartment_id
    items {
        domain = "${oci_core_instance.instance_gfclient[count.index].display_name}.${var.domain}"
        rdata = oci_core_instance.instance_gfclient[count.index].private_ip
        rtype = "A"
        ttl = 3600
    }
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
