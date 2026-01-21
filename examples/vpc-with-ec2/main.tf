# VPC with EC2 Example
# Creates a VPC with EC2 instances distributed across public subnets

provider "aws" {
  region = var.aws_region
}

module "vpc_with_ec2" {
  source = "../../"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "vpc-with-ec2-example"
  }

  subnet_config = {
    public_subnet_1 = {
      cidr_block = "10.0.0.0/24"
      azs        = "${var.aws_region}a"
      public     = true
    }
    public_subnet_2 = {
      cidr_block = "10.0.1.0/24"
      azs        = "${var.aws_region}b"
      public     = true
    }
    private_subnet = {
      cidr_block = "10.0.10.0/24"
      azs        = "${var.aws_region}c"
      public     = false
    }
  }

  ec2_config = {
    create_instance   = true
    instance_count    = 2
    ami_id            = var.ami_id
    instance_type     = "t3.micro"
    key_name          = var.key_name
    use_public_subnet = true
    name_prefix       = "web-server"
    ssh_cidr_blocks   = var.allowed_ssh_cidr
    additional_tags = {
      Environment = "development"
      Project     = "terraform-example"
      ManagedBy   = "terraform"
    }
  }
}
