# Basic VPC Example
# This example creates a simple VPC with one public and one private subnet

provider "aws" {
  region = var.aws_region
}

module "basic_vpc" {
  source = "../../"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "basic-vpc-example"
  }

  subnet_config = {
    public_subnet = {
      cidr_block = "10.0.1.0/24"
      azs        = "${var.aws_region}a"
      public     = true
    }
    private_subnet = {
      cidr_block = "10.0.2.0/24"
      azs        = "${var.aws_region}b"
      public     = false
    }
  }

  # No EC2 instances in this example
  ec2_config = {
    create_instance = false
  }
}
