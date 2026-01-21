# VPC with EC2 Example

# Creates a VPC with EC2 instances distributed across public subnets

```tf
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
```

# variables.tf:

```tf
# variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  # Amazon Linux 2023 in us-east-1
  default = "ami-0c55b159cbfafe1f0"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  # You must create this key pair in AWS first
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH"
  type        = list(string)
  # Restrict to your IP for security
  default = ["0.0.0.0/0"]
}
```

# outputs.tf:

```tf
# outputs.tf
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc_with_ec2.vpc_id
}

output "ec2_instance_ids" {
  description = "EC2 instance IDs"
  value       = module.vpc_with_ec2.ec2_instance_ids
}

output "ec2_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.vpc_with_ec2.ec2_instance_public_ips
}

output "ssh_command" {
  description = "SSH command to connect to instances"
  value = [
    for ip in module.vpc_with_ec2.ec2_instance_public_ips :
    "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${ip}"
  ]
}
```
