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
  vpc_id              = var.vpc_id
  service_name        = local.api_gw_service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnets_ids
  security_group_ids  = [aws_security_group.vpce_access.id]
  private_dns_enabled = true
  auto_accept         = true
  tags = tomap({
    environment      = var.name_suffix,
    application_role = "network",
    created_by       = "terraform"
  })
}

resource "aws_lb_target_group" "tg_vpce" {
  name        = "tg-${var.name_suffix}-api-gw"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path                = "/"
    protocol            = "HTTPS"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "403"
  }

}

resource "aws_lb_target_group_attachment" "tg_vpce" {
  count = length(var.private_subnets_ids)
  target_group_arn = aws_lb_target_group.tg_vpce.arn
  target_id = tolist(data.aws_network_interface.vpce_enis[*].private_ip)[count.index]

}

/*
  export api gateway related data as ssm parameters for sam integration
*/
resource "aws_ssm_parameter" "vpce_id" {
  name  = "/infra/${var.name_suffix}/vpce_id"
  type  = "SecureString"
  value = aws_vpc_endpoint.execute_api.id
}

/*
  export api gateway related data as ssm parameters for sam integration
*/
resource "aws_ssm_parameter" "private_subnets_ids" {
  name  = "/infra/${var.name_suffix}/private_subnets_ids"
  # type = "SecureString"
  type  = "StringList"
  value = join(",", var.private_subnets_ids)
}

/*
  export api gateway related data as ssm parameters for sam integration
*/
resource "aws_ssm_parameter" "vpce_security_groups" {
  name  = "/infra/${var.name_suffix}/vpce_security_groups"
  # type = "SecureString"
  type  = "StringList"
  value = var.default_security_group_id
}
