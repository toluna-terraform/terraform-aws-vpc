locals{
    aws_azs = slice(data.aws_availability_zones.available.names[*], 0, var.number_of_azs)
}


module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name            = var.env_name
    cidr            = var.vpc_cidr
    azs             = local.aws_azs
    

    private_subnets = tolist(["192.168.0.0/24","192.168.1.0/24"])
    public_subnets = tolist(["192.168.2.0/24","192.168.3.0/24"])

    enable_nat_gateway = true
    enable_vpn_gateway = false

    tags = tomap({
                Name="vpc-${var.env_name}",
                environment=var.env_name,
                application_role="network",
                created_by="terraform"
    })

}

provider "aws" {
    region = var.aws_region
    profile = var.aws_profile
}