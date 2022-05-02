output "example_vpc_id" {
    value = module.example_vpc.attributes.vpc_id
}

output "example_vpc" {
    value = module.example_vpc
    sensitive = true
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

output "nat_instance" {
   value = module.example_vpc.nat_instance
}

output "nat_instance_id" {
   value = module.example_vpc.nat_instance_id
}

output "private_api_vpce" {
   value = module.example_vpc.private_api_vpce
}

