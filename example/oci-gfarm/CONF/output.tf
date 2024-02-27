output "instance" {
  value = {
    for inst in concat(oci_core_instance.instance_gfmd,
                       oci_core_instance.instance_gfsd) :
      inst.display_name => {
        "public_ip" = inst.public_ip
        "OCPUs" = inst.shape_config[0].ocpus
        "availability_domain" = inst.availability_domain
        "compartment_id" = inst.compartment_id
      }
  }
}
