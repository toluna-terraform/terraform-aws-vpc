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