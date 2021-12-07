

// VPCE resource for ECS:
resource "aws_security_group" "allow_https_ecs_vpce" {
  name        = "sg-allow-https-ecs-vpce-${var.env_name}"
  description = "Allow HTTPS inbound traffic"
  vpc_id      = var.aws_vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.selected.cidr_block]
    ipv6_cidr_blocks = [data.aws_vpc.selected.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_endpoint" "ecs_agent" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecs-agent"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.allow_https_ecs_vpce.id,
  ]

  private_dns_enabled = true
}


resource "aws_vpc_endpoint" "ecs_telemetry" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecs-telemetry"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.allow_https_ecs_vpce.id,
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecs" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.allow_https_ecs_vpce.id,
  ]

  private_dns_enabled = true
}


// VPCE resource for ECR:
resource "aws_security_group" "allow_https_ecr_vpce" {
  name        = "sg-allow-https-ecr-vpce-${var.env_name}"
  description = "Allow HTTPS inbound traffic"
  vpc_id      = var.aws_vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.selected.cidr_block]
    ipv6_cidr_blocks = [data.aws_vpc.selected.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.allow_https_ecr_vpce.id,
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.allow_https_ecr_vpce.id,
  ]

  private_dns_enabled = true
}