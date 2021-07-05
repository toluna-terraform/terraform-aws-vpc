output "attributes" {
    value = { for key, value in module.vpc : key => value }
}

output "vpce_target_group" {
    value = var.enable_private_api ? module.private_api_vpce[0].vpce_target_group : null
}