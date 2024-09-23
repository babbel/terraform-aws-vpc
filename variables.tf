variable "db_subnet_group_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the DB subnet group created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "cidr_block" {
  type = string

  description = <<EOS
VPC CIDR.
EOS
}

variable "create_db_subnet_group" {
  type    = bool
  default = false

  description = <<EOS
Whether to create a DB subnet group.
EOS
}

variable "create_elasticache_subnet_group" {
  type    = bool
  default = false

  description = <<EOS
Whether to create an ElastiCache subnet group.
EOS
}

variable "default_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to all AWS resources created by this module.
EOS
}

variable "internet_gateway_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the Internet Gateway created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "name" {
  type = string

  description = <<EOS
Name to be used in all `Name` tags shown in the AWS Console.
EOS
}

variable "nat_gateway_eip_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the EIPs of the NAT Gateways created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "nat_gateway_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the NAT Gateways created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "private_route_table_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the private route tables created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "private_subnet_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the private subnets created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "public_route_table_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the public route tables created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "public_subnet_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the public subnets created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "size" {
  type = number

  description = <<EOS
Number of availability zones to cover.

This will be also the number public-private subnet pairs to create.
If subnet groups for RDS and/or ElastiCache shall be created, the number must be at least 2.
EOS
}

variable "subnet_bits" {
  type    = number
  default = 4

  description = <<EOS
Number of bits to add to the VPC CIDR to get the size of the subnet CIDR.
EOS
}

variable "vpc_endpoints" {
  type = object({
    gateway   = list(string)
    interface = list(string)
  })
  default = {
    gateway   = []
    interface = []
  }

  description = <<EOS
Service name identifiers for the VPC endpoints.

Every VPC endpoint belongs to a service name like `com.amazonaws.REGION.IDENTIFIER`.
The lists of this variable (grouped by VPC endpoint type) are expecting just the `IDENTIFIER` of the service name.
EOS
}

variable "vpc_gateway_endpoint_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the VPC Endpoints with type `Gateway` created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "interface_vpc_endpoint_security_group_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the security groups of the VPC Endpoints with type `Interface` created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "interface_vpc_endpoint_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the VPC Endpoints with type `Interface` created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "vpc_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the VPC created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}
