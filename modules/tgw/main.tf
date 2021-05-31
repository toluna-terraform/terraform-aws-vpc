provider "aws" {
    region = var.aws_region
}

locals{
    route_cidr = split(",",data.aws_ssm_parameter.route_cidr.value)
}

// Create the VPC attachment  - Child Account
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_attachment" {
  count              = var.create_tgw_attachment ? 1 : 0
  subnet_ids         = var.private_subnets
  transit_gateway_id = data.aws_ssm_parameter.tgw_id.value
  vpc_id             = var.aws_vpc_id
}

// Add routes  - Child Account
resource "aws_route" "route_0" {
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc_attachment]
  for_each                    = var.create_tgw_attachment ? data.aws_route_tables.route_tables.ids : []
  route_table_id              = each.value
  transit_gateway_id          = data.aws_ssm_parameter.tgw_id.value
  destination_cidr_block      = local.route_cidr[0]
}
// Add routes  - Child Account
resource "aws_route" "route_1" {
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc_attachment]
  for_each                    = var.create_tgw_attachment ? data.aws_route_tables.route_tables.ids : []
  route_table_id              = each.value
  transit_gateway_id          = data.aws_ssm_parameter.tgw_id.value
  destination_cidr_block      = local.route_cidr[1]
}