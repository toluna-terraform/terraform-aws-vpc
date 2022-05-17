output "tgw_vpc_attachment" {
    value = aws_ec2_transit_gateway_vpc_attachment.vpc_attachment
}

output "tgw_vpc_attachment_id" {
    value = aws_ec2_transit_gateway_vpc_attachment.vpc_attachment.id
}

