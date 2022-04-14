output "example_vpc_id" {
    value = module.example_vpc.attributes.vpc_id
}

output "igw_id" {
    value = module.example_vpc.attributes.igw_id
}

output "public_subnets" {
    value = module.example_vpc.attributes.public_subnets[0]
}

output "private_subnets" {
    value = module.example_vpc.attributes.private_subnets[0]
}


output "natgw_id" {
    value = module.example_vpc.attributes.natgw_ids
}
