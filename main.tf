locals{
    config = jsondecode(file("./config.json"))
    
}


module "vpc" {
    source = "./modules/vpc"
    aws_azs = slice(data.aws_availability_zones.available.names[*], 0, local.config.number_of_azs)
    aws_region = local.config.aws_region
    vpc_cidr = local.config.vpc_cidr
    env_name = local.config.env_name 
    tags = tomap({
                Name="vpc-${local.config.env_name}",
                environment=local.config.env_name,
                application_role="network",
                created_by="terraform"
    })
}

provider "aws" {
    region = local.config.aws_region
    profile = local.config.aws_profile
}