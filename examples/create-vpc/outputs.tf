output "exampleVpcId" {
    value = module.exampleVpc.attributes.vpc_id
}

output "igwId" {
    value = module.exampleVpc.attributes.igw_id
}

output "natgwId" {
    value = module.exampleVpc.attributes.natgw_ids
}

