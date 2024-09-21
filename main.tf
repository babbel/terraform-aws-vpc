data "aws_region" "current" {}

# VPC

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  # required for VPC endpoints with type `Interface`
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({ Name = var.name }, var.default_tags, var.vpc_tags)
}

# Internet Gateway

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge({ Name = var.name }, var.default_tags, var.internet_gateway_tags)
}

# Pairs of Public-Private Subnets per Availability Zone

module "availability_zone" {
  source = "./availability-zone"
  count  = var.size

  vpc              = aws_vpc.this
  internet_gateway = aws_internet_gateway.this

  subnet_bits  = var.subnet_bits
  subnet_index = count.index

  nat_gateway_eip_tags     = var.nat_gateway_eip_tags
  nat_gateway_tags         = var.nat_gateway_tags
  private_route_table_tags = var.private_route_table_tags
  private_subnet_tags      = var.private_subnet_tags
  public_route_table_tags  = var.public_route_table_tags
  public_subnet_tags       = var.public_subnet_tags

  default_tags = var.default_tags
}

# Subnet Groups (RDS, ElastiCache)

resource "aws_db_subnet_group" "this" {
  count = var.create_db_subnet_group ? 1 : 0

  name        = var.name
  description = var.name

  subnet_ids = module.availability_zone[*].private_subnet.id

  tags = merge(var.default_tags, var.db_subnet_group_tags)
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

  tags = merge({ Name = each.key }, var.default_tags, var.gateway_vpc_endpoint_tags)
}

# VPC Endpoints: type `Interface`

resource "aws_vpc_endpoint" "interface" {
  for_each = toset(var.vpc_endpoints.interface)

  vpc_id = aws_vpc.this.id

  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = module.availability_zone[*].private_subnet.id
  security_group_ids = [aws_security_group.vpc-endpoints-interface[0].id]

  tags = merge({ Name = each.key }, var.default_tags, var.interface_vpc_endpoint_tags)

  depends_on = [
    aws_security_group_rule.vpc-endpoints-interface-ingress,
    aws_security_group_rule.vpc-endpoints-interface-egress,
  ]
}

resource "aws_security_group" "vpc-endpoints-interface" {
  count = length(var.vpc_endpoints.interface) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  name        = "vpc-endpoints-interface"
  description = "VPC Endpoints Interface"

  tags = merge({ Name = "VPC Endpoints Interface" }, var.default_tags, var.interface_vpc_endpoint_security_group_tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "vpc-endpoints-interface-ingress" {
  count = length(var.vpc_endpoints.interface) > 0 ? 1 : 0

  security_group_id = aws_security_group.vpc-endpoints-interface[count.index].id

  cidr_blocks = [aws_vpc.this.cidr_block]

  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "vpc-endpoints-interface-egress" {
  count = length(var.vpc_endpoints.interface) > 0 ? 1 : 0

  security_group_id = aws_security_group.vpc-endpoints-interface[count.index].id

  cidr_blocks = ["0.0.0.0/0"]

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  lifecycle {
    create_before_destroy = true
  }
}
