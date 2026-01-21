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
