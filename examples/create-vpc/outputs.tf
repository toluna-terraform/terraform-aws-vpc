output "example_vpc_id" {
    value = module.exampleVpc.attributes.vpc_id
}

output "igw_id" {
    value = module.exampleVpc.attributes.igw_id
}

output "public_subnets" {
    value = module.exampleVpc.attributes.public_subnets[0]
}

output "private_subnets" {
    value = module.exampleVpc.attributes.private_subnets[0]
}


output "natgwId" {
    value = module.exampleVpc.attributes.natgw_ids
}
