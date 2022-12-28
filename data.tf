data "aws_availability_zones" "available" {}

data "aws_ssm_parameter" "network_range" {
    count = var.multi_service ? 0 : 1
    name = "/infra/network_address_range"
}

data "aws_ssm_parameter" "network_range_per_app" {
    count = var.multi_service ? 1 : 0
    name = "/infra/${var.app_name}/network_address_range"
}

data "aws_ssm_parameter" "domain_name" {
    name = "/infra/dhcp_options_set/domain_name"    
}

data "aws_ssm_parameter" "dns_servers" {
    name = "/infra/dhcp_options_set/dns_servers"    
}

data "aws_vpc_dhcp_options" "default_dhcp_options" {

  filter {
    name   = "key"
    values = [ "domain-name" ]
  }
  filter {
    name   = "value"
    values = [ "ec2.internal" ]
  }

}

data "aws_region" "current" {}

