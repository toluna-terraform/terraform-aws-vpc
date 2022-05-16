locals{
    private_rtb_ids = data.aws_route_tables.route_tables.ids
    destination_cidrs = split(",",data.aws_ssm_parameter.route_cidr.value)
    rtb_map = setproduct(var.private_rtb_ids,local.destination_cidrs)
    rtb_size = length(var.private_rtb_ids[*])*length(local.destination_cidrs)
}



// Create the VPC attachment  - Child Account
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_attachment" {
  subnet_ids         = var.private_subnets
  transit_gateway_id = data.aws_ssm_parameter.tgw_id.value
  vpc_id             = var.aws_vpc_id
}

// Add routes  - Child Account
resource "aws_route" "tgw_routes" {
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc_attachment]
  count = local.rtb_size
  route_table_id              = local.rtb_map[count.index][0]
  destination_cidr_block      = local.rtb_map[count.index][1]
  transit_gateway_id          = data.aws_ssm_parameter.tgw_id.value
}
