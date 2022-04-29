
data "aws_ssm_parameter" "tgw_id" {
    name = "/infra/tgw/tgw_id"    
}

data "aws_ssm_parameter" "tgw_role" {
    name = "/infra/tgw/tgw_role"    
}

data "aws_ssm_parameter" "tgw_region" {
    name = "/infra/tgw/tgw_region"    
}

data "aws_ssm_parameter" "resource_share_name" {
    name = "/infra/tgw/resource_share_name"    
}

data "aws_ssm_parameter" "route_cidr" {
    name = "/infra/tgw/route_cidr"    
}

data "aws_ssm_parameter" "is_shared" {
    name = "/infra/tgw/is_shared"    
}

data "aws_ec2_transit_gateway" "tgw" {
  id        = data.aws_ssm_parameter.tgw_id.value
}

// Get Account ID
data "aws_caller_identity" "attachment_account" {}

// Get Share ARN
//data "aws_ram_resource_share" "tgw_share" {
  //resource_owner = "OTHER-ACCOUNTS"
  //name           = data.aws_ssm_parameter.resource_share_name.value
//}

// Get RouteTables
data "aws_route_tables" "route_tables" {
  vpc_id   = var.aws_vpc_id
}

