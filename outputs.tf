output "public_subnet_ids" {
  description = "list with ids of the public subnets"
  value       = aws_subnet.public_subnet.*.id
}

output "private_subnet_ids" {
  description = "list with ids of the private-app subnets"
  value       = aws_subnet.private_subnet.*.id
}

output "private_subnet_db_ids" {
  description = "list with ids of the private-db subnets"
  value       = aws_subnet.private_subnet_db.*.id
}

output "private_subnet_management_ids" {
  description = "list with ids of the private-management subnets"
  value       = aws_subnet.private_subnet_management.*.id
}

output "vpc_id" {
  description = "id of the vpc"
  value       = aws_vpc.my_vpc.id
}

output "az_public_id" {
  value = zipmap(var.aws_azs, aws_subnet.public_subnet.*.id)
}

output "az_private_id" {
  value = zipmap(var.aws_azs, aws_subnet.private_subnet.*.id)
}

output "az_private_db_id" {
  value = zipmap(var.aws_azs, aws_subnet.private_subnet_db.*.id)
}

output "az_private_management_id" {
  value = zipmap(var.aws_azs, aws_subnet.private_subnet_management.*.id)
}

output "route_tables_ids" {
  value = concat(list(aws_route_table.route.id), aws_route_table.private_route.*.id, list(aws_route_table.private_route_db.id))
}

output "rtb_public" {
  value = aws_route_table.route.id
}

output "rtb_private_db" {
  value = aws_route_table.private_route_db.id
}

output "rtb_private" {
  value = aws_route_table.private_route.*.id
}

output "igw" {
  value = aws_internet_gateway.my_gw.id
}

output "nat" {
  value = aws_nat_gateway.nat.*.id
}