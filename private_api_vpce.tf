/*
    Private API-Gateway integration
    - creating vpc endpoint
    - creating alb target groups
    - attaching vpce enis as targets
    - export required sam parameters to ssm
*/
locals {
  api_gw_service_name = "com.amazonaws.${data.aws_region.current.name}.execute-api"
}

resource "aws_vpc_endpoint" "execute_api" {
  count               = "${var.enable_private_api ? 1 : 0}"
  vpc_id              = module.vpc.vpc_id
  service_name        = local.api_gw_service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids  = [ aws_security_group.vpce_access.id ]
  private_dns_enabled = true
  auto_accept         = true
  tags = tomap({
    environment      = var.env_name,
    application_role = "network",
    created_by       = "terraform"
  })
}

resource "aws_lb_target_group" "tg_vpce" {
  count       = "${var.enable_private_api ? 1 : 0}"
  name        = "tg-${var.env_name}-vpce-execute-api"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path = "/"
    protocol = "HTTPS"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "403"
  }

}

resource "aws_lb_target_group_attachment" "tg_vpce" {
  for_each         = data.aws_network_interface.vpce_enis
  target_group_arn = aws_lb_target_group.tg_vpce[0].arn
  target_id        = each.value.private_ip

}

/*
  export api gateway related data as ssm parameters for sam integration
*/
resource "aws_ssm_parameter" "vpce_id" {
  count = "${var.enable_private_api ? 1 : 0}"
  name  = "/infra/${var.env_name}/vpce_id"
  type  = "String"
  value = aws_vpc_endpoint.execute_api[0].id
}

/*
  export api gateway related data as ssm parameters for sam integration
*/
resource "aws_ssm_parameter" "private_subnets_ids" {
  count = "${var.enable_private_api ? 1 : 0}"
  name  = "/infra/${var.env_name}/private_subnets_ids"
  type  = "StringList"
  value = join(",", module.vpc.private_subnets)
}

/*
  export api gateway related data as ssm parameters for sam integration
*/
resource "aws_ssm_parameter" "vpce_security_groups" {
  count = "${var.enable_private_api ? 1 : 0}"
  name  = "/infra/${var.env_name}/vpce_security_groups"
  type  = "StringList"
  value = module.vpc.default_security_group_id
}