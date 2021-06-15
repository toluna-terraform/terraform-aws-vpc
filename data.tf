data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

data "aws_ssm_parameter" "network_range" {
    name = "/infra/network_address_range"    
}

data "aws_network_interface" "vpce_enis" {
    for_each = aws_vpc_endpoint.execute_api[0].network_interface_ids
    id = each.key
}
