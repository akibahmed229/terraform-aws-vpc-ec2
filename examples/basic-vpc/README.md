# Basic VPC Example

# This example creates a simple VPC with one public and one private subnet

# main.tf

```tf
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
```

# variables.tf

```tf
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}
```

# outputs.tf

```tf
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.basic_vpc.vpc_id
}

output "public_subnet" {
  description = "List of public subnet IDs"
  value       = module.basic_vpc.public_subnets
}

output "private_subnet" {
  description = "List of private subnet IDs"
  value       = module.basic_vpc.private_subnets
}
```
