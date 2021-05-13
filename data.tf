data "aws_availability_zones" "available" {}

data "aws_ssm_parameter" "network_range" {
    name = "/infra/network_address_range"    
}

data "aws_ssm_parameter" "vpcs" {
    name = "/infra/available_vpcs"    
}

data "aws_ssm_parameter" "tgw_id" {
    name = "/infra/tgw_id"    
}

data "aws_ssm_parameter" "tgw_role" {
    name = "/infra/tgw_role"    
}

data "aws_ssm_parameter" "tgw_region" {
    name = "/infra/tgw_region"    
}

data "aws_ssm_parameter" "resource_share_name" {
    name = "/infra/resource_share_name"    
}

data "aws_ssm_parameter" "route_cidr" {
    name = "/infra/route_cidr"    
}

data "aws_ssm_parameter" "is_shared" {
    name = "/infra/is_shared"    
}

data "aws_ec2_transit_gateway" "tgw" {
  id        = data.aws_ssm_parameter.tgw_id.value
}

// Get Account ID
data "aws_caller_identity" "attachment_account" {}

// Get Share ARN
data "aws_ram_resource_share" "tgw_share" {
  resource_owner = "SELF"
  name           = data.aws_ssm_parameter.resource_share_name.value
}

// Get RouteTables
data "aws_route_tables" "route_tables" {
  vpc_id   = module.vpc.vpc_id
}

