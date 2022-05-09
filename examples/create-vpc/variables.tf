variable "env_name" {
    type = string
    description = "Environment name for which VPC is getting created."
    default = "test-create-vpc"
}

variable "number_of_azs" {
    type = number
    description = "Number of AZs to created in the VPC."
    default = 2
}

variable "env_type" {
    type = string
    default = "non-prod"
    description = "specifies prod or non-prod."
}

variable "env_index" {
    type = number
    description = "Indicates size of VPC addresses. Pl refer module doc for details."
}

variable "create_nat_gateway" {
    type = bool
    description = "Flag indicating if NAT GW to be created or not."
    default = false
}

variable "create_nat_instance" {
    type = bool
    description = "Flag indicating if NAT Instance to be created or not."
    default = false
}

variable "nat_instance_type" {
    type = string
    description = "ec2 instance type for NAT instnace, if it needs to be created."
    default = "t3.nano"
}

variable "create_tgw_attachment" {
    type = bool
    description = "Flag indicating if Transit Gateway attachment created or not"
    default = false
}

variable "enable_private_api" {
    type = bool
    description = "Flag indicating if private-api to be enabled. Applicable for AWS SAM applications."
    default = false
}

variable "create_ecs_vpce" {
    type = bool
    description = "Flag indicating if VPE Endpoint to be created for ECS. Applicable for ECS based applications."
    default = false
}

variable "enable_dhcp_options" {
    type = bool
    description = "Flag indicating if DHCP optoins to be enabled ."
    default = false
}

variable "dhcp_options_domain_name" {
    type = string
    description = "Domain Name in DHCP options."
    default = "devops-main-toluna.com"
}

variable "dhcp_options_domain_name_servers" {
    type = list(string)
    description = "List of Domain Name servers"
    default = ["AmazonProvidedDNS"]
}
