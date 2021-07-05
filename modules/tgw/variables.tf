variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "number_of_azs" {
  type = number
}
