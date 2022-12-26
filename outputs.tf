output "attributes" {
    value = { for key, value in module.vpc : key => value }
    description = "All the internal VPC modules output parameters"
    sensitive = true
}

output "vpce_target_group" {
    value = var.enable_private_api ? module.private_api_vpce[0].vpce_target_group : null
    description = "Optional - VPC endpoint ENIs target group"
}

output "nat_instance" {
    value = module.nat_instance
}

output "nat_instance_id" {
    value = length(module.nat_instance) > 0 ? module.nat_instance[0].nat_instance.id : null
}

output "tgw_vpc_attachment" {
    value = length(module.tgw) > 0 ? module.tgw[0].tgw_vpc_attachment : null
    sensitive = true
}

output "tgw_vpc_attachment_id" {
    value = length(module.tgw) > 0 ? module.tgw[0].tgw_vpc_attachment.id : null
}

output "private_api_vpce" {
    value = module.private_api_vpce
}

output "default_dhcp_options" {
    value = data.aws_vpc_dhcp_options.default_dhcp_options
}

output "aws_region" {
    value = data.aws_region.current.name
}
# output "network_address_range" {
#   value = "${ var.lookup_ssm_param == false ? cidrsubnet(data.aws_ssm_parameter.network_range.value, 5, var.env_index) : cidrsubnet(data.aws_ssm_parameter.network_range_per_app[0].value, 5, var.env_index) }"
# }
