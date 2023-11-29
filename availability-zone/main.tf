data "aws_availability_zones" "all" {}

locals {
  availability_zone = data.aws_availability_zones.all.names[var.subnet_index]
}

# Public Subnet

resource "aws_route_table" "public" {
  vpc_id = var.vpc.id

  tags = merge({ Name = "public - ${local.availability_zone}" }, var.tags)
}

resource "aws_route" "internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway.id
}

resource "aws_subnet" "public" {
  vpc_id = var.vpc.id

  cidr_block              = cidrsubnet(var.vpc.cidr_block, var.subnet_bits, 2 * var.subnet_index)
  availability_zone       = local.availability_zone
  map_public_ip_on_launch = true

  tags = merge({ Name = "public - ${local.availability_zone}" }, var.tags)
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway

resource "aws_eip" "this" {
  domain = "vpc"

  tags = merge({ Name = local.availability_zone }, var.tags)
}

resource "aws_nat_gateway" "this" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.this.id

  tags = merge({ Name = local.availability_zone }, var.tags)
}

# Private Subnet

resource "aws_route_table" "private" {
  vpc_id = var.vpc.id

  tags = merge({ Name = "private - ${local.availability_zone}" }, var.tags)
}

resource "aws_route" "nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_subnet" "private" {
  vpc_id = var.vpc.id

  cidr_block              = cidrsubnet(var.vpc.cidr_block, var.subnet_bits, 2 * var.subnet_index + 1)
  availability_zone       = local.availability_zone
  map_public_ip_on_launch = false

  tags = merge({ Name = "private - ${local.availability_zone}" }, var.tags)
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
