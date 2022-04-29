 variable "env_name" {
     type = string
     description = "Environment unique identifier"
 }
 variable "number_of_azs" {
     type = number
     default = 2
     description = "Number of Availability Zones to setup"
 }
 variable "env_type" {
     type = string
     default = "non-prod"
     description = "Environment Cardinality: prod or non-prod"
 }

 variable "env_index" {
     type = number
     description = "The VPC CIDR subnet index, extracted from the whole available network address range of the account."
 }

 variable "create_tgw_attachment"{
     type = bool
     default = false
     description = "Attach a Transite Gateway to the VPC and update related route tables"
 }

 variable "enable_private_api"{
     type = bool
     default = false
     description = "For SAM integration - Create VPC endpoint and required resources and export them as SSM params"
 }

 variable "create_ecs_vpce" {
     type = bool
     default = false
     description = "Set this variable to true when you want to create VPCEs for ECS and ECR (PrivateLinks)."
 }

 variable "create_nat_gateway" {
     type = bool
     default = false
 }
 
 variable "create_nat_instance" {
     description = "Set to true if you want your private networks to reach the internet"
     type = bool
     default = false
 }

 variable "nat_instance_type" {
     description = "Amazon linux instance type for NAT instance. The instance type affects the network performace (and cost). See the link in vpc.tf"
     type        = string
     default     = "t3.nano"
 }

variable "enable_dhcp_options" {
    type = bool
    description = "Flag indicating if DHCP optoins to be enabled ."
    default = false
}

variable "dhcp_options_domain_name" {
    type = string
    description = "Domain Name in DHCP options set."
    default = "devops-toluna.com"
}

variable "dhcp_options_domain_name_servers" {
    type = list(string)
    description = "List of domain name servers"
    default = ["AmazonProvidedDNS"]
}
