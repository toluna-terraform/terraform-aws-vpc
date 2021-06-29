variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_vpc_id" {
  type = string
}

variable "create_tgw_attachment" {
  type    = bool
  default = false
}

variable "private_subnets" {
  type = list(string)
}

variable "number_of_azs" {
  type = number
}
