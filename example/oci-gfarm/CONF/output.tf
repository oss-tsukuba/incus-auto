output "detail" {
  value = {
    for inst in concat([oci_core_instance.instance_manage],
                       oci_core_instance.instance_gfmd,
                       oci_core_instance.instance_gfsd,
                       oci_core_instance.instance_gfclient) :
      inst.display_name => {
        "public_ip" = inst.public_ip
        "shape" = inst.shape
        "OCPUs" = inst.shape_config[0].ocpus
        "memory" = inst.shape_config[0].memory_in_gbs
        "source_id" = inst.source_details[0].source_id
        "availability_domain" = inst.availability_domain
        "compartment_id" = inst.compartment_id
        #"ssh_authorized_keys" = inst.metadata.ssh_authorized_keys
        #"user_data" = base64decode(inst.metadata.user_data)
      }
  }
}

output "host" {
  value = {
    "manage" = {
      for inst in concat([oci_core_instance.instance_manage]) :
        inst.display_name => {
          "public_ip" = inst.public_ip
          "private_ip" = inst.private_ip
          "user" = var.admin_user
          "subnet_domain_name" = data.oci_core_subnet.gfarm_subnet.subnet_domain_name
        }
    }
    "gfmd" = {
      for inst in concat(oci_core_instance.instance_gfmd) :
        inst.display_name => {
          "public_ip" = inst.public_ip
          "private_ip" = inst.private_ip
          "user" = var.gfmd_admin_user
        }
    }
    "gfsd" = {
      for inst in concat(oci_core_instance.instance_gfsd) :
        inst.display_name => {
          "public_ip" = inst.public_ip
          "private_ip" = inst.private_ip
          "user" = var.gfsd_admin_user
        }
    }
    "gfclient" = {
      for inst in concat(oci_core_instance.instance_gfclient) :
        inst.display_name => {
          "public_ip" = inst.public_ip
          "private_ip" = inst.private_ip
          "user" = var.gfclient_admin_user
        }
    }
  }
}
