locals {
    environment = terraform.workspace
    name_suffix = "${var.app_name}-${local.environment}"
}