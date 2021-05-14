 variable "aws_profile" {
     type = string
 }

 variable "env_name" {
     type = string
     default = "test-devops"
 }

 variable "aws_region" {
     type = string
     default = "us-east-1"
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
     default = 1
 }

 variable "create_tgw_attachment"{
     type = bool
     default = false
 }