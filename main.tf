locals{
    config = jsondecode(file("config.json"))
    
}


module "vpc" {
    source = "./modules/vpc"
    aws_azs = slice(data.aws_availability_zones.available.names[*], 0, locals.config.number_of_azs)
    aws_region = locals.config.aws_region
    vpc_cidr = locals.config.vpc_cidr
    env_name = locals.config.env_name 
    tags = map(
                "Name", "vpc-${locals.config.env_name}",
                "environment", locals.config.env_name,
                "application_role", "network",
                "created_by", "terraform"
                )
}

provider "aws" {
    region = locals.config.aws_region
    profile = locals.config.aws_profile
}