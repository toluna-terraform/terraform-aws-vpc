data "aws_vpc" "selected" {
    id = var.aws_vpc_id
}

data "aws_region" "current" {}

data "aws_route_table" "route_table_1" {
  subnet_id = var.private_subnets_ids[0]
}

data "aws_route_table" "route_table_2" {
  subnet_id = var.private_subnets_ids[1]
}
