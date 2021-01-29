variable "internet_gateway" {
  description = "Internet Gateway which belongs to `var.vpc`"

  type = object({
    id = string
  })
}

variable "subnet_bits" {
  description = <<EOS
Number of bits to add to the VPC CIDR to get the size of the subnet CIDR

This will be the `newbits` argument of [`cidrsubnet`](https://www.terraform.io/docs/language/functions/cidrsubnet.html).
EOS

  type = number
}

variable "subnet_index" {
  description = <<EOS
The number of the subnet which will be used to calculate the subnet CIDR

This will be used in the `netnum` argument of [`cidrsubnet`](https://www.terraform.io/docs/language/functions/cidrsubnet.html):

* for the public subnet, it will be `2 * var.subnet_index`,
* for the private subnet, it will be `2 * var.subnet_index + 1`.
EOS

  type = number
}

variable "tags" {
  description = "Map of tags to assign to all resources supporting tags (in addition to the `Name` tag)"

  type = map(string)
}

variable "vpc" {
  description = "VPC in which the subnets and routing tables will be created"

  type = object({
    id         = string
    cidr_block = string
  })
}
