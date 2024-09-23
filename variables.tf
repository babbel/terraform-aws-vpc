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

variable "name" {
  type = string

  description = <<EOS
Name to be used in all `Name` tags shown in the AWS Console.
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
