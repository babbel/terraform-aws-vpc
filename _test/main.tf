provider "aws" {
  region = "local"
}

module "vpc" {
  source = "./.."

  name       = "example"
  cidr_block = "10.0.0.0/16"
  size       = 2

  vpc_endpoints = {
    gateway   = ["dynamodb", "s3"]
    interface = ["logs"]
  }

  default_tags = {
    app = "example"
    env = "production"
  }
}
