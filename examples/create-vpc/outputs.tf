output "exampleVpcId" {
    value = module.exampleVpc.attributes.vpc_id
    sensitive = true
}


output "natgw-id" {
    value = module.exampleVpc.attributes.natgw_ids
    sensitive = true
}

