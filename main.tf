locals{
    
    aws_azs = slice(data.aws_availability_zones.available.names[*], 0, var.number_of_azs)
    
}


module "vpc" {
    source = "./modules/vpc"
    aws_azs = local.aws_azs
    aws_region = var.aws_region
    vpc_cidr = var.vpc_cidr
    env_name = var.env_name 
    tags = tomap({
                Name="vpc-${var.env_name}",
                environment=var.env_name,
                application_role="network",
                created_by="terraform"
    })
    private_subnets = tolist(["192.168.0.0/24","192.168.1.0/24"])
    public_subnets = tolist(["192.168.2.0/24","192.168.3.0/24"])
}

provider "aws" {
    region = var.aws_region
    profile = var.aws_profile
}