output "private_route_table" {
  description = "Private route table"
  value       = aws_route_table.private
}

output "public_route_table" {
  description = "Public route table"
  value       = aws_route_table.public
}

output "private_subnet" {
  description = "Private subnet"
  value       = aws_subnet.private
}

output "public_subnet" {
  description = "Public subnet"
  value       = aws_subnet.public
}
