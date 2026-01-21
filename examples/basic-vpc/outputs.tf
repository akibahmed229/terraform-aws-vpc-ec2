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
