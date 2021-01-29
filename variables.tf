variable "cidr_block" {
  description = "VPC CIDR"

  type = string
}

variable "create_db_subnet_group" {
  description = "Whether to create a DB subnet group"

  type    = bool
  default = false
}

variable "create_elasticache_subnet_group" {
  description = "Whether to create an ElastiCache subnet group"

  type    = bool
  default = false
}

variable "name" {
  description = "Name to be used in all `Name` tags shown in the AWS Console"

  type = string
}

variable "size" {
  description = <<EOS
Number of availability zones to cover

This will be also the number public-private subnet pairs to create.
If subnet groups for RDS and/or ElastiCache shall be created, the number must be at least 2.
EOS

  type = number
}

variable "subnet_bits" {
  description = "Number of bits to add to the VPC CIDR to get the size of the subnet CIDR"

  type    = number
  default = 4
}

variable "tags" {
  description = "Map of tags to assign to all resources supporting tags (in addition to the `Name` tag)"

  type = map(string)
}

variable "vpc_endpoints" {
  description = <<EOS
Service name identifiers for the VPC endpoints.

Every VPC endpoint belongs to a service name like `com.amazonaws.REGION.IDENTIFIER`.
The lists of this variable (grouped by VPC endpoint type) are expecting just the `IDENTIFIER` of the service name.
EOS

  type = object({
    gateway   = list(string)
    interface = list(string)
  })
  default = {
    gateway   = []
    interface = []
  }
}
