# VPC Outputs
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}
output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet Outputs - Formatted for easy access
locals {
  # To format the subnet IDs which may be multiples in format of subnet_name = {id=, azs=}
  public_subnets_output = {
    for key, config in local.public_subnet : key =>
    {
      subnet_id = aws_subnet.main[key].id
      azs       = aws_subnet.main[key].availability_zone
      cidr      = aws_subnet.main[key].cidr_block
    }
  }

  private_subnets_output = {
    for key, config in local.private_subnet : key =>
    {
      subnet_id = aws_subnet.main[key].id
      azs       = aws_subnet.main[key].availability_zone
      cidr      = aws_subnet.main[key].cidr_block
    }

  }
}

# Subnet Details
output "public_subnets" {
  description = "Map of public subnet details (ID, AZ, CIDR)"
  value       = local.public_subnets_output
}
output "private_subnets" {
  description = "Map of private subnet details (ID, AZ, CIDR)"
  value       = local.private_subnets_output
}

# EC2 Instance Outputs
output "ec2_instance_ids" {
  description = "IDs of created EC2 instances"
  value       = aws_instance.main[*].id
}

output "ec2_instance_private_ips" {
  description = "Private IP addresses of EC2 instances"
  value       = aws_instance.main[*].private_ip
}

output "ec2_instance_public_ips" {
  description = "Public IP addresses of EC2 instances (if in public subnet)"
  value       = aws_instance.main[*].public_ip
}
