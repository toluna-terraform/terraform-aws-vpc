module "example_vpc" {
    source = "../.."

    env_name = var.env_name
    number_of_azs = var.number_of_azs
    env_type = var.env_type
    env_index = var.env_index 

    create_nat_gateway = var.create_nat_gateway
    create_nat_instance = var.create_nat_instance
    nat_instance_type = var.nat_instance_type
    create_tgw_attachment = var.create_tgw_attachment
    enable_private_api = var.enable_private_api
    create_ecs_vpce = var.create_ecs_vpce

    enable_dhcp_options = var.enable_dhcp_options
    dhcp_options_domain_name = var.dhcp_options_domain_name
    dhcp_options_domain_name_servers = var.dhcp_options_domain_name_servers
}
