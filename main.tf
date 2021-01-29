data "aws_region" "current" {}

# VPC

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  # required for VPC endpoints with type `Interface`
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({ Name = var.name }, var.tags)
}

# Internet Gateway

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge({ Name = var.name }, var.tags)
}

# Pairs of Public-Private Subnets per Availability Zone

module "availability_zone" {
  source = "./availability-zone"
  count  = var.size

  vpc              = aws_vpc.this
  internet_gateway = aws_internet_gateway.this

  subnet_bits  = var.subnet_bits
  subnet_index = count.index

  tags = var.tags
}

# Subnet Groups (RDS, ElastiCache)

resource "aws_db_subnet_group" "this" {
  count = var.create_db_subnet_group ? 1 : 0

  name        = var.name
  description = var.name

  subnet_ids = module.availability_zone[*].private_subnet.id

  tags = var.tags
}

resource "aws_elasticache_subnet_group" "this" {
  count = var.create_elasticache_subnet_group ? 1 : 0

  name        = var.name
  description = var.name

  subnet_ids = module.availability_zone[*].private_subnet.id
}

# VPC Endpoints: type `Gateway`

resource "aws_vpc_endpoint" "gateway" {
  for_each = toset(var.vpc_endpoints.gateway)

  vpc_id = aws_vpc.this.id

  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type = "Gateway"

  route_table_ids = module.availability_zone[*].private_route_table.id

  tags = merge({ Name = "${var.name} ${each.key}" }, var.tags)
}

# VPC Endpoints: type `Interface`

resource "aws_vpc_endpoint" "interface" {
  for_each = toset(var.vpc_endpoints.interface)

  vpc_id = aws_vpc.this.id

  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = module.availability_zone[*].private_subnet.id
  security_group_ids = [aws_security_group.vpc-endpoints.id]

  tags = merge({ Name = "${var.name} ${each.key}" }, var.tags)
}

resource "aws_security_group" "vpc-endpoints" {
  vpc_id = aws_vpc.this.id

  name        = "${var.name} vpc-endpoints"
  description = "${var.name} vpc-endpoints"

  tags = merge({ Name = "${var.name} vpc-endpoints" }, var.tags)
}

resource "aws_security_group_rule" "vpc-endpoints-ingress" {
  security_group_id = aws_security_group.vpc-endpoints.id

  cidr_blocks = [aws_vpc.this.cidr_block]

  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
}

resource "aws_security_group_rule" "vpc-endpoints-egress" {
  security_group_id = aws_security_group.vpc-endpoints.id

  cidr_blocks = ["0.0.0.0/0"]

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
}
