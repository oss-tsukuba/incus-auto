locals {
  instances = {
    "gfmd" = { ol_ver = var.gfmd_ol_ver }
    "gfsd" = { ol_ver = var.gfsd_ol_ver }
    "gfclient" = { ol_ver = var.gfclient_ol_ver }
  }
}

data "template_file" "cloud-init_gfarm" {
  for_each = local.instances

  template = file("./user_data/cloud-init_gfarm.cfg")
  vars = {
    ol_ver = each.value.ol_ver != "" ? each.value.ol_ver : var.oracle_linux_version
    admin_user = var.admin_user
    timezone = var.timezone
    ssh_authorized_keys = file(var.ssh_authorized_keys)
    subnet_domain_name = data.oci_core_subnet.gfarm_subnet.subnet_domain_name
  }
}

data "template_file" "cloud-init_manage" {
  template = file("./user_data/cloud-init_manage.cfg")
  vars = {
    ol_ver = var.manage_ol_ver != "" ? var.manage_ol_ver : var.oracle_linux_version
    admin_user = var.admin_user
    timezone = var.timezone
    ssh_authorized_keys = file(var.ssh_authorized_keys)
    subnet_domain_name = data.oci_core_subnet.gfarm_subnet.subnet_domain_name
  }
}
