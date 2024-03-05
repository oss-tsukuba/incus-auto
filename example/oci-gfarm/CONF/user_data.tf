data "template_file" "cloud-init_gfarm-ol8" {
  template = file("./user_data/cloud-init_gfarm.cfg")
  vars = {
    ol_ver = "OL8"
    admin_user = var.admin_user
    timezone = var.timezone
    ssh_authorized_keys = file(var.ssh_authorized_keys)
    subnet_domain_name = data.oci_core_subnet.gfarm_subnet.subnet_domain_name
  }
}

data "template_file" "cloud-init_gfarm-ol9" {
  template = file("./user_data/cloud-init_gfarm.cfg")
  vars = {
    ol_ver = "OL9"
    admin_user = var.admin_user
    timezone = var.timezone
    ssh_authorized_keys = file(var.ssh_authorized_keys)
    subnet_domain_name = data.oci_core_subnet.gfarm_subnet.subnet_domain_name
  }
}

data "template_file" "cloud-init_manage" {
  template = file("./user_data/cloud-init_manage.cfg")
  vars = {
    admin_user = var.admin_user
    timezone = var.timezone
    ssh_authorized_keys = file(var.ssh_authorized_keys)
    subnet_domain_name = data.oci_core_subnet.gfarm_subnet.subnet_domain_name
  }
}
