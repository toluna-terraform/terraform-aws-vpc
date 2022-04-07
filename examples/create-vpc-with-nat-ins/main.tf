module "vpc" {
    source = "../.."

    env_name = "butter"
    number_of_azs = 2
    env_type = "non-prod"
    env_index = 8 

    create_tgw_attachment = false
    enable_private_api = false
    create_ecs_vpce = false
    create_nat_gateway = false
    create_nat_instance = true
    nat_instance_type = "t3.nano"

}
