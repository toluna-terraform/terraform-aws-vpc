output "vpce_target_group" {
    value = aws_lb_target_group.tg_vpce
}

output "private_api_vpce" {
    value = aws_vpc_endpoint.execute_api
}
