resource "aws_security_group" "vpce_access" {
    name = "api_gw_vpce_access"
    description = "Access control for execute api vpc endopint"
    vpc_id = var.vpc_id
    tags = tomap({
        environment      = var.name_suffix,
        application_role = "network",
        created_by       = "terraform"
    })
}

resource "aws_security_group_rule" "https_from_vpc" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ var.vpc_cidr_block ]
    description = "HTTPS access from entire VPC"
    security_group_id = aws_security_group.vpce_access.id
}



