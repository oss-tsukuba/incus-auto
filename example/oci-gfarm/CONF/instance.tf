resource "oci_core_instance" "instance_gfmd" {
    count = var.gfmd_num
    availability_domain = var.availability_domain
    compartment_id = var.compartment_id != "" ? var.compartment_id : var.availability_domain

    #TODO
    # https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm#vmshapes__vm-standard
    #shape = "VM.Standard.A1.Flex"
    shape = "VM.Standard3.Flex"

    #TODO
    source_details {
        # Oracle-Linux-8.9-aarch64-2024.01.26-0
        # https://docs.oracle.com/iaas/images/image/b2b2f4cb-515b-49e0-b08c-1fb07be8da5d/
        # ap-tokyo-1
        #source_id = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaakoj4yfoziwsrfzxk7n5aq2qp3habdji67366mon22rkni6fxd3bq"

        # Oracle-Linux-8.9-2024.01.26-0 (x86_64)
        # https://docs.oracle.com/en-us/iaas/images/image/59e0d507-ff8e-4e58-9047-bc6921734b58/
        # ap-tokyo-1
        source_id = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaaki7d7tmydzgtgkxli3pfdi75xtpjyukzt64pv2uixayk6pqak7qa"
        source_type = "image"
    }

    shape_config {
        ocpus                 = var.gfsd_ocpus
        memory_in_gbs         = var.gfsd_mem
    }

    display_name       = "${format("gfmd%03d", count.index + 1)}"

    create_vnic_details {
        assign_public_ip = true
        subnet_id = var.subnet_id
    }

    #TODO
    metadata = {
        ssh_authorized_keys = file("/CONF/sshkey.pub")
    }
    preserve_boot_volume = false
}

resource "oci_core_instance" "instance_gfsd" {
    count = var.gfsd_num

    availability_domain = var.availability_domain

    #compartment_id = var.compartment_id
    compartment_id = var.compartment_id != "" ? var.compartment_id : var.availability_domain

    # https://docs.oracle.com/ja-jp/iaas/Content/Compute/References/computeshapes.htm#vmshapes__vm-standard
    #shape = "VM.Standard.A1.Flex"
    shape = "VM.Standard3.Flex"

    source_details {
        # Oracle-Linux-8.9-aarch64-2024.01.26-0
        # https://docs.oracle.com/iaas/images/image/b2b2f4cb-515b-49e0-b08c-1fb07be8da5d/
        # ap-tokyo-1
        #source_id = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaakoj4yfoziwsrfzxk7n5aq2qp3habdji67366mon22rkni6fxd3bq"

        # Oracle-Linux-8.9-2024.01.26-0 (x86_64)
        # https://docs.oracle.com/en-us/iaas/images/image/59e0d507-ff8e-4e58-9047-bc6921734b58/
        # ap-tokyo-1
        source_id = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaaki7d7tmydzgtgkxli3pfdi75xtpjyukzt64pv2uixayk6pqak7qa"
        source_type = "image"
    }

    shape_config {
        ocpus                 = var.gfsd_ocpus
        memory_in_gbs         = var.gfsd_mem
    }

    display_name       = "${format("gfsd%03d", count.index + 1)}"

    create_vnic_details {
        assign_public_ip = true
        subnet_id = var.subnet_id
    }
    metadata = {
        ssh_authorized_keys = file("/CONF/sshkey.pub")
    }
    preserve_boot_volume = false
}
