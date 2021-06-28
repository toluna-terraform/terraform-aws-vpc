data "aws_availability_zones" "available" {}
data "aws_ssm_parameter" "network_range" {
    name = "/infra/network_address_range"    
}