output "this" {
  description = "VPC"
  value       = aws_vpc.this
}

output "private_subnets" {
  description = "Private subnets"
  value       = module.availability_zone[*].private_subnet
}

output "public_subnets" {
  description = "Public subnets"
  value       = module.availability_zone[*].public_subnet
}
