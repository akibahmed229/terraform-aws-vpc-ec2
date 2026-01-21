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
