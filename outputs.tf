output "db_subnet_group" {
  description = "DB subnet group containing all private subnets"
  value = var.create_db_subnet_group ? aws_db_subnet_group.this : null
}

output "db_elasticache_subnet_group" {
  description = "ElastiCache subnet group containing all private subnets"
  value = var.create_db_elasticache_subnet_group ? aws_db_elasticache_subnet_group.this : null
}

output "private_subnets" {
  description = "Private subnets"
  value       = module.availability_zone[*].private_subnet
}

output "public_subnets" {
  description = "Public subnets"
  value       = module.availability_zone[*].public_subnet
}

output "this" {
  description = "VPC"
  value       = aws_vpc.this
}
