 variable "aws_profile" {
     type = string
     default = "ts-non-prod"
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

 variable "vpc_cidr" {
     type = string
     default = "192.168.0.0/16"
 }
