# VPC, incl. Subnets, Routing, NAT Gateway, and VPC Endpoints

This module creates a simple VPC for a given number of availability zones.

For every availability zone, there will be pair with a public and a private subnet, incl. NAT gateway for the outgoing traffic of the private subnet.

In addition, VPC endpoints (both `Gateway` and `Interface`) can be created.

## Example Usage

```tf
module "vpc" {
  source  = "babbel/vpc/aws"
  version = "~> 1.1"

  name       = "example"
  cidr_block = "10.0.0.0/16"
  size       = 2

  vpc_endpoints = {
    gateway   = ["dynamodb", "s3"]
    interface = ["logs"]
  }

  tags = {
    app = "example"
    env = "production"
  }
}
```
