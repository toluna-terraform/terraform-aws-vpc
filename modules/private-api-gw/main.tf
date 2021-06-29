/*
    Private API-Gateway integration
    - creating vpc endpoint
    - creating alb target groups
    - attaching vpce enis as targets
    - export required sam parameters to ssm
*/
locals {
  api_gw_service_name = "com.amazonaws.${data.aws_region.current.name}.execute-api"
  enis = join("_", aws_vpc_endpoint.execute_api.network_interface_ids[*])
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
    environment      = var.env_name,
    application_role = "network",
    created_by       = "terraform"
  })
}

resource "aws_lb_target_group" "tg_vpce" {
  name        = "tg-${var.env_name}-vpce-execute-api"
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
  # depends_on = [
  #   aws_vpc_endpoint.execute_api
  # ]
  count = length(var.private_subnets_ids)
  # count = length(aws_vpc_endpoint.execute_api.network_interface_ids)
  # for_each         = aws_vpc_endpoint.execute_api.network_interface_ids
  # for_each         = toset(data.aws_network_interface.vpce_enis.id)
  target_group_arn = aws_lb_target_group.tg_vpce.arn
  # target_id        = each.value.private_ip
  #target_id = split("_",join("_", aws_vpc_endpoint.execute_api.network_interface_ids[*]))[count.index]
  # target_id = tolist(aws_vpc_endpoint.execute_api.network_interface_ids[*].private_ip)[count.index]
  target_id = tolist(data.aws_network_interface.vpce_enis[*].private_ip)[count.index]

}

/*
  export api gateway related data as ssm parameters for sam integration
*/
resource "aws_ssm_parameter" "vpce_id" {
  name  = "/infra/${var.env_name}/vpce_id"
  type  = "String"
  value = aws_vpc_endpoint.execute_api.id
}

/*
  export api gateway related data as ssm parameters for sam integration
*/
resource "aws_ssm_parameter" "private_subnets_ids" {
  name  = "/infra/${var.env_name}/private_subnets_ids"
  type  = "StringList"
  value = join(",", var.private_subnets_ids)
}

/*
  export api gateway related data as ssm parameters for sam integration
*/
resource "aws_ssm_parameter" "vpce_security_groups" {
  name  = "/infra/${var.env_name}/vpce_security_groups"
  type  = "StringList"
  value = var.default_security_group_id
}
