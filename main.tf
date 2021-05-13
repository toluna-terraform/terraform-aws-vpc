provider "aws" {
    region = var.aws_region
    profile = var.aws_profile
}

locals{
    aws_azs = slice(data.aws_availability_zones.available.names[*], 0, var.number_of_azs)
    vpc_cidr = cidrsubnet(data.aws_ssm_parameter.network_range.value,4,var.env_index)
    public_subnets = tolist([cidrsubnet(local.vpc_cidr,3,0),cidrsubnet(local.vpc_cidr,3,1)])
    private_subnets = tolist([cidrsubnet(local.vpc_cidr,3,2),cidrsubnet(local.vpc_cidr,3,3)])
    database_subnets = tolist([cidrsubnet(local.vpc_cidr,3,4),cidrsubnet(local.vpc_cidr,3,5)])
    route_cidr = split(",",data.aws_ssm_parameter.route_cidr.value)
}


module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    name            = var.env_name
    cidr            = local.vpc_cidr
    azs             = local.aws_azs
    private_subnets = local.private_subnets
    public_subnets = local.public_subnets
    database_subnets = local.database_subnets
    enable_nat_gateway = true
    enable_vpn_gateway = false
    tags = tomap({
                Name="vpc-${var.env_name}",
                environment=var.env_name,
                application_role="network",
                created_by="terraform"
    })

}


// Add account id to existing TGW Share - Main Account
resource "aws_ram_principal_association" "principal_association" {
  count              = var.create_tgw_attachment && !data.aws_ssm_parameter.is_shared.value ? 1 : 0 
  
  principal          = data.aws_caller_identity.attachment_account.account_id
  resource_share_arn = data.aws_ram_resource_share.tgw_share.id
}

// Accept the shared resource - Child Account
resource "aws_ram_resource_share_accepter" "receiver_accept" {
  count         = var.create_tgw_attachment && !data.aws_ssm_parameter.is_shared.value ? 1 : 0
  depends_on    = [aws_ram_principal_association.principal_association]
  share_arn     = aws_ram_principal_association.principal_association[0].resource_share_arn
}

// Create the VPC attachment  - Child Account
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_attachment" {
  depends_on = [aws_ram_principal_association.principal_association,aws_ram_resource_share_accepter.receiver_accept]
  count              = var.create_tgw_attachment ? 1 : 0
  subnet_ids         = local.private_subnets
  transit_gateway_id = data.aws_ssm_parameter.tgw_id.value
  vpc_id             = module.vpc.vpc_id
}

// Add routes  - Child Account
resource "aws_route" "route_0" {
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc_attachment]
  for_each                    = var.create_tgw_attachment ? data.aws_route_tables.route_tables.ids : []
  route_table_id              = each.value
  transit_gateway_id          = data.aws_ssm_parameter.tgw_id.value
  destination_cidr_block      = local.route_cidr[0]
}
// Add routes  - Child Account
resource "aws_route" "route_1" {
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc_attachment]
  for_each                    = var.create_tgw_attachment ? data.aws_route_tables.route_tables.ids : []
  route_table_id              = each.value
  transit_gateway_id          = data.aws_ssm_parameter.tgw_id.value
  destination_cidr_block      = local.route_cidr[1]
}