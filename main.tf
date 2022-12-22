locals {
  # calualte available AZs for current region
  aws_azs = slice(data.aws_availability_zones.available.names[*], 0, var.number_of_azs)

  # calculate VPC and subnets CIDRs
  vpc_cidr         = cidrsubnet(data.aws_ssm_parameter.network_range.value, 5, var.env_index)
  public_subnets   = tolist([cidrsubnet(local.vpc_cidr, 2, 0), cidrsubnet(local.vpc_cidr, 2, 1)])
  private_subnets  = tolist([cidrsubnet(local.vpc_cidr, 2, 2), cidrsubnet(local.vpc_cidr, 2, 3)])

  domain_name = data.aws_ssm_parameter.domain_name.value
  dns_servers = tolist(split(",", data.aws_ssm_parameter.dns_servers.value))
}


module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~>3.13.0"
  name                 = var.env_name
  cidr                 = local.vpc_cidr
  azs                  = local.aws_azs
  private_subnets      = local.private_subnets
  public_subnets       = local.public_subnets
  enable_dns_hostnames = true
  enable_nat_gateway   = var.create_nat_gateway
  single_nat_gateway   = var.create_nat_gateway
  enable_vpn_gateway   = false

  enable_dhcp_options = var.enable_dhcp_options
  dhcp_options_domain_name = local.domain_name
  dhcp_options_domain_name_servers = local.dns_servers

  default_network_acl_egress = var.default_network_acl_egress

  tags = tomap({
    environment      = var.env_name,
    application_role = "network",
    created_by       = "terraform"
  })

}

resource "aws_vpc_dhcp_options_association" "dhcp" {

  // if DHCP options not enabled, assign default DHCP options
  count = ( var.enable_dhcp_options == false ) ? 1 : 0

  vpc_id          = module.vpc.vpc_id
  dhcp_options_id = data.aws_vpc_dhcp_options.default_dhcp_options.dhcp_options_id

  depends_on = [
      module.vpc
  ]

}

module "tgw" {
  source                = "./modules/tgw"
  count                 = (var.create_tgw_attachment ? 1 : 0)
  aws_vpc_id            = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  private_rtb_ids       = module.vpc.private_route_table_ids
}

module "ecs_vpce" {
  # source                = "../terraform-aws-vpces"
  source                = "toluna-terraform/vpces/aws"
  version               = "~>0.0.5"
  region                = data.aws_region.current.name

  count                 = (var.create_ecs_vpce ? 1 : 0)

  env_name              = var.env_name
  create_ecs_vpce       = var.create_ecs_vpce
  aws_vpc_id            = module.vpc.vpc_id
  private_subnets_ids   = module.vpc.private_subnets

  depends_on = [
    module.vpc
  ]
}

module "nat_instance" {
  source                = "./modules/nat-instance"
  count                 = (var.create_nat_instance ? 1 : 0)
  env_name              = var.env_name
  number_of_azs         = var.number_of_azs
  aws_vpc_id            = module.vpc.vpc_id
  nat_instance_type     = var.nat_instance_type
  public_subnets_ids    = module.vpc.public_subnets
  private_subnets_ids   = module.vpc.private_subnets
  
  depends_on = [
    module.vpc
  ]
}

module "private_api_vpce" {
  source                    = "./modules/private-api-gw"
  count                     = (var.enable_private_api ? 1 : 0)
  vpc_id                    = module.vpc.vpc_id
  private_subnets_ids       = module.vpc.private_subnets
  default_security_group_id = module.vpc.default_security_group_id
  vpc_cidr_block            = module.vpc.vpc_cidr_block
  env_name                  = var.env_name
}
