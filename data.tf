data "aws_availability_zones" "available" {}

data "aws_ssm_parameter" "network_range" {
    name = "/infra/network_address_range"    
}

data "aws_ssm_parameter" "domain_name" {
    name = "/infra/dhcp_options_set/domain_name"    
}

data "aws_ssm_parameter" "dns_servers" {
    name = "/infra/dhcp_options_set/dns_servers"    
}

data "aws_vpc_dhcp_options" "default_dhcp_options" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}

data "aws_region" "current" {}

