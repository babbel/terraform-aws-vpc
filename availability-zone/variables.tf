variable "default_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to all AWS resources created by this module.
EOS
}

variable "internet_gateway" {
  type = object({
    id = string
  })

  description = <<EOS
Internet Gateway which belongs to `var.vpc`.
EOS
}

variable "nat_gateway_eip_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the EIP of the NAT Gateway created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "nat_gateway_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the NAT Gateway created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "private_route_table_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the private route table created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "private_subnet_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the private subnet created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "public_route_table_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the public route table created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "public_subnet_tags" {
  type    = map(string)
  default = {}

  description = <<EOS
Map of tags assigned to the public subnet created by this module. Tags in this map will override tags in `var.default_tags`.
EOS
}

variable "subnet_bits" {
  type = number

  description = <<EOS
Number of bits to add to the VPC CIDR to get the size of the subnet CIDR.

This will be the `newbits` argument of [`cidrsubnet`](https://www.terraform.io/docs/language/functions/cidrsubnet.html).
EOS
}

variable "subnet_index" {
  type = number

  description = <<EOS
The number of the subnet which will be used to calculate the subnet CIDR.

This will be used in the `netnum` argument of [`cidrsubnet`](https://www.terraform.io/docs/language/functions/cidrsubnet.html):

* for the public subnet, it will be `2 * var.subnet_index`,
* for the private subnet, it will be `2 * var.subnet_index + 1`.
EOS
}

variable "vpc" {
  type = object({
    id         = string
    cidr_block = string
  })

  description = <<EOS
VPC in which the subnets and routing tables will be created.
EOS
}
