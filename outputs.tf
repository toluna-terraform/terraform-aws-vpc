output "attributes" {
    value = { for key, value in module.vpc : key => value }
}

output "vpce_target_group" {
    value = aws_lb_target_group.tg_vpce[0]
}