 variable "env_name" {
     type = string
 }
 variable "number_of_azs" {
     type = number
     default = 2
 }
 variable "env_type" {
     type = string
     default = "non-prod"
 }

 variable "env_index" {
     type = number
 }

 variable "create_tgw_attachment"{
     type = bool
     default = false
 }

 variable "enable_sam_integration"{
     type = bool
     default = false
 }