output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_1.id
}

output "private_subnet_id" {
  value = aws_subnet.private_1.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  value = aws_route_table.rtb_public.id
}

output "private_route_table_id" {
  value = aws_route_table.rtb_private_1.id
}
