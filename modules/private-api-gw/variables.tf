variable "vpc_id" {
  type = string
}

variable "private_subnets_ids" {
  type = list(string)
}

variable "default_security_group_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "name_suffix" {
    type = string
    description = ""
}