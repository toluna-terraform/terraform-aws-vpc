locals {
  # calualte available AZs for current region
  aws_azs = slice(data.aws_availability_zones.available.names[*], 0, var.number_of_azs)

  # calculate VPC and subnets CIDRs
  vpc_cidr         = cidrsubnet(data.aws_ssm_parameter.network_range.value, 4, var.env_index)
  public_subnets   = tolist([cidrsubnet(local.vpc_cidr, 3, 0), cidrsubnet(local.vpc_cidr, 3, 1)])
  private_subnets  = tolist([cidrsubnet(local.vpc_cidr, 3, 2), cidrsubnet(local.vpc_cidr, 3, 3)])
  database_subnets = tolist([cidrsubnet(local.vpc_cidr, 3, 4), cidrsubnet(local.vpc_cidr, 3, 5)])
}


module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = var.env_name
  cidr                 = local.vpc_cidr
  azs                  = local.aws_azs
  private_subnets      = local.private_subnets
  public_subnets       = local.public_subnets
  database_subnets     = local.database_subnets
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_vpn_gateway   = false
  tags = tomap({
    environment      = var.env_name,
    application_role = "network",
    created_by       = "terraform"
  })

}

module "tgw" {
  source                = "./modules/tgw"
  aws_vpc_id            = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  create_tgw_attachment = var.create_tgw_attachment
}


