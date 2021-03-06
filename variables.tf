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
     description = "Flag to enable or disable dhcp options set"
     type        = bool
     default     = false
 }

variable "default_network_acl_egress" {
    type = list(map(string))
    description = "List of ACL egress rules"
    default = [{ "rule_no": 100, "action": "allow", "cidr_block": "0.0.0.0/0", "from_port": 0, "protocol": "-1",  "to_port": 0 } ]
}
