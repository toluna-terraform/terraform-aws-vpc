data "aws_region" "current" {}

data "aws_network_interface" "vpce_enis" {
    count = length(var.private_subnets_ids)
    id = element(tolist(aws_vpc_endpoint.execute_api.network_interface_ids[*]),count.index)
    # for_each = aws_vpc_endpoint.execute_api[0].network_interface_ids
    # id = each.key
}