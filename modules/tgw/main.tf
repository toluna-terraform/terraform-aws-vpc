locals{
    route_cidr = split(",",data.aws_ssm_parameter.route_cidr.value)
}

// Create the VPC attachment  - Child Account
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_attachment" {
  subnet_ids         = var.private_subnets
  transit_gateway_id = data.aws_ssm_parameter.tgw_id.value
  vpc_id             = var.aws_vpc_id
}

// Add routes  - Child Account
resource "aws_route" "route_0" {
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc_attachment]
  count = length(var.private_rtb_ids)
  route_table_id = var.private_rtb_ids[count.index]
  transit_gateway_id          = data.aws_ssm_parameter.tgw_id.value
  destination_cidr_block      = local.route_cidr[0]
}
// Add routes  - Child Account
resource "aws_route" "route_1" {
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc_attachment]
  count = length(var.private_rtb_ids)
  route_table_id = var.private_rtb_ids[count.index]
  transit_gateway_id          = data.aws_ssm_parameter.tgw_id.value
  destination_cidr_block      = local.route_cidr[1]
}
// Add routes  - Child Account
resource "aws_route" "route_2" {
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc_attachment]
  count = length(var.private_rtb_ids)
  route_table_id = var.private_rtb_ids[count.index]
  transit_gateway_id          = data.aws_ssm_parameter.tgw_id.value
  destination_cidr_block      = local.route_cidr[2]
}
