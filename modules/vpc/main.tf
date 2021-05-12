module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name            = var.env_name
    cidr            = var.vpc_cidr
    azs             = var.aws_azs
    

    private_subnets = var.private_subnets
    public_subnets  = var.public_subnets

    enable_nat_gateway = true
    enable_vpn_gateway = false

    tags = var.tags

}