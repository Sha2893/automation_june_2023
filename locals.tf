locals {
  vpc_name_label = "${var.vpc_name} - SR"
  web_server     = "${var.web_server_name} - SR"
  bastion_host   = "${var.vpc_name} - bastion_host-SR"
}