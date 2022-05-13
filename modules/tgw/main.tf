locals{
    private_rtb_ids = var.private_rtb_ids
    destination_cidrs = split(",",data.aws_ssm_parameter.route_cidr.value)
    
    RouteTableCidrEntries = flatten([
	    for rt_id in local.private_rtb_ids : [
            for cidr in local.destination_cidrs : {
                  rt_id = rt_id
                  cidr = cidr
            }
        ]			
   ])
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
  
  for_each = { for entry, record in nonsensitive(local.RouteTableCidrEntries) : entry => record }

  route_table_id              = each.value.rt_id
  transit_gateway_id          = data.aws_ssm_parameter.tgw_id.value
  destination_cidr_block      = each.value.cidr
}
