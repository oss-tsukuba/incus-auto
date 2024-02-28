data "template_file" "cloud-init_gfarm-ol8" {
  template = file("./user_data/cloud-init_gfarm.cfg")
  vars = {
    ol_ver = "OL8"
  }
}

data "template_file" "cloud-init_gfarm-ol9" {
  template = file("./user_data/cloud-init_gfarm.cfg")
  vars = {
    ol_ver = "OL9"
  }
}
