# Terraform VPC with EC2 Module

This module creates a custom VPC with configurable subnets (public/private) and optional EC2 instances.

## Features

- ✅ Custom VPC with configurable CIDR block
- ✅ Multiple public and private subnets across AZs
- ✅ Internet Gateway for public subnet internet access
- ✅ Automatic route table configuration
- ✅ Optional EC2 instance creation with security groups
- ✅ Flexible instance deployment (public or private subnets)
- ✅ DNS support enabled for VPC

## Module Structure

```
ec2_with_vpc/
├── main.tf          # Main resources (VPC, subnets, IGW, EC2, SG)
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── versions.tf      # Terraform and provider versions
└── README.md        # This file
```

## Usage

### Basic VPC without EC2

```hcl
module "basic_vpc" {
  source = "./ec2_with_vpc"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "my-vpc"
  }

  subnet_config = {
    public_subnet = {
      cidr_block = "10.0.1.0/24"
      azs        = "ap-southeast-2a"
      public     = true
    }
  }
}
```

### VPC with EC2 Instances

```hcl
module "vpc_with_instances" {
  source = "./ec2_with_vpc"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "prod-vpc"
  }

  subnet_config = {
    public_subnet_1 = {
      cidr_block = "10.0.0.0/24"
      azs        = "ap-southeast-2a"
      public     = true
    }
    public_subnet_2 = {
      cidr_block = "10.0.1.0/24"
      azs        = "ap-southeast-2b"
      public     = true
    }
    private_subnet = {
      cidr_block = "10.0.10.0/24"
      azs        = "ap-southeast-2c"
      public     = false
    }
  }

  ec2_config = {
    create_instance    = true
    instance_count     = 2
    ami_id             = "ami-0b8d527345fdace59"
    instance_type      = "t3.micro"
    key_name           = "my-key-pair"
    use_public_subnet  = true
    name_prefix        = "web-server"
    ssh_cidr_blocks    = ["203.0.113.0/24"]  # Restrict to your IP
    additional_tags = {
      Environment = "production"
      Team        = "DevOps"
    }
  }
}
```

## Input Variables

### vpc_config (required)

| Field      | Type   | Description            |
| ---------- | ------ | ---------------------- |
| cidr_block | string | CIDR block for the VPC |
| name       | string | Name tag for the VPC   |

### subnet_config (required)

Map of subnet configurations:

| Field      | Type   | Required | Default | Description               |
| ---------- | ------ | -------- | ------- | ------------------------- |
| cidr_block | string | yes      | -       | CIDR block for the subnet |
| azs        | string | yes      | -       | Availability zone         |
| public     | bool   | no       | false   | Whether subnet is public  |

### ec2_config (optional)

| Field             | Type         | Default       | Description                        |
| ----------------- | ------------ | ------------- | ---------------------------------- |
| create_instance   | bool         | false         | Enable EC2 instance creation       |
| instance_count    | number       | 1             | Number of instances to create      |
| ami_id            | string       | ""            | AMI ID for the instance            |
| instance_type     | string       | "t3.micro"    | EC2 instance type                  |
| key_name          | string       | null          | SSH key pair name                  |
| use_public_subnet | bool         | true          | Deploy in public vs private subnet |
| name_prefix       | string       | "instance"    | Name prefix for instances          |
| ssh_cidr_blocks   | list(string) | ["0.0.0.0/0"] | CIDR blocks for SSH access         |
| additional_tags   | map(string)  | {}            | Additional tags for instances      |

## Outputs

| Output                   | Description                   |
| ------------------------ | ----------------------------- |
| vpc_id                   | ID of the created VPC         |
| vpc_cidr                 | CIDR block of the VPC         |
| public_subnets           | Map of public subnet details  |
| private_subnets          | Map of private subnet details |
| public_subnet_ids        | List of public subnet IDs     |
| private_subnet_ids       | List of private subnet IDs    |
| internet_gateway_id      | ID of the Internet Gateway    |
| ec2_security_group_id    | ID of the EC2 security group  |
| ec2_instance_ids         | List of EC2 instance IDs      |
| ec2_instance_private_ips | List of private IP addresses  |
| ec2_instance_public_ips  | List of public IP addresses   |

## Important Notes

1. **SSH Access**: Default security group allows SSH from anywhere (`0.0.0.0/0`). **Restrict this in production!**
2. **Key Pair**: You must create an EC2 key pair before using `key_name`
3. **AMI ID**: Update the AMI ID based on your region and required OS
4. **Public IPs**: EC2 instances in public subnets automatically get public IPs
5. **Instance Distribution**: Multiple instances are distributed across available subnets using modulo

## Security Recommendations

- Restrict `ssh_cidr_blocks` to your IP range
- Use private subnets for databases and backend services
- Implement additional security groups based on application needs
- Enable VPC Flow Logs for monitoring
- Use AWS Systems Manager Session Manager instead of SSH when possible

## Requirements

- Terraform >= 1.14.0
- AWS Provider >= 6.28.0
- Valid AWS credentials configured

## Example Commands

```bash
# Initialize Terraform
terraform init

# Plan the infrastructure
terraform plan

# Apply the configuration
terraform apply

# Destroy the infrastructure
terraform destroy
```
