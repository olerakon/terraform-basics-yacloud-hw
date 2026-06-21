locals {
  vm_web_local_name = "${var.vm_web_env}-${var.vm_web_role}-${var.vm_web_user}"
  vm_db_local_name  = "${var.vm_db_env}-${var.vm_db_role}-${var.vm_db_user}"
}
