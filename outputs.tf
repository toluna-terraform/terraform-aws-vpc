output "attributes" {
    value = { for key, value in module.vpc : key => value }
}

output "vpce_target_group" {
    value = module.private_api_vpce.vpce_target_group
}