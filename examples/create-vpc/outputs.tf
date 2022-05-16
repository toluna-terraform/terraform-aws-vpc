output "example_vpc_id" {
    value = module.example_vpc.attributes.vpc_id
}

output "example_vpc" {
    value = module.example_vpc
    sensitive = true
}

output "dhcp_options_set_id" {
    value = module.example_vpc.attributes.dhcp_options_id
}

output "igw_id" {
    value = module.example_vpc.attributes.igw_id
}

output "public_subnets" {
    value = module.example_vpc.attributes.public_subnets
}

output "private_subnets" {
    value = module.example_vpc.attributes.private_subnets
}

output "natgw_id" {
    value = length(module.example_vpc.attributes.natgw_ids) > 0 ? module.example_vpc.attributes.natgw_ids[0] : null
}

output "nat_instance" {
   value = module.example_vpc.nat_instance
}

output "nat_instance_id" {
   value = module.example_vpc.nat_instance_id
}

output "tgw_vpc_attachment" {
   value = module.example_vpc.tgw_vpc_attachment
   sensitive = true
}

output "tgw_vpc_attachment_id" {
   value = module.example_vpc.tgw_vpc_attachment_id
}

output "private_api_vpce" {
   value = module.example_vpc.private_api_vpce
}
