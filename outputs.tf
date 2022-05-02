output "attributes" {
    value = { for key, value in module.vpc : key => value }
    description = "All the internal VPC modules output parameters"
}

output "vpce_target_group" {
    value = var.enable_private_api ? module.private_api_vpce[0].vpce_target_group : null
    description = "Optional - VPC endpoint ENIs target group"
}

output "nat_instance" {
    value = module.nat_instance
}

output "nat_instance_id" {
    value = module.nat_instance[0].nat_instance.id
}
