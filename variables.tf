variable "vpc_config" {
  description = "To get the CIDR and Name of VPC from the user"

  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "Invalid CIDR fromat - ${var.vpc_config.cidr_block}"
  }
}

variable "subnet_config" {
  # sub1 = { cidr=.. azs=.. }
  description = "Get the CIDR and availability zone for the subnet"

  type = map(object({
    cidr_block = string
    azs        = string
    public     = optional(bool, false)
  }))

  validation {
    # sub1 = { cidr=..} , [true, false, true]
    condition = alltrue([
      for config in var.subnet_config :
      can(cidrnetmask(config.cidr_block))
    ])
    error_message = "Invalid CIDR fromat"
  }
}

# EC2 Instance Configuration
variable "ec2_config" {
  description = "Configuration for EC2 instances (optional)"

  type = object({
    create_instance   = optional(bool, false)                 # Set to true to create instances
    instance_count    = optional(number, 1)                   # Number of instances to create
    ami_id            = optional(string, "")                  # AMI ID for the instance
    instance_type     = optional(string, "t3.micro")          # Instance type
    key_name          = optional(string, null)                # SSH key pair name
    use_public_subnet = optional(bool, true)                  # Deploy in public or private subnet
    name_prefix       = optional(string, "instance")          # Name prefix for instances
    ssh_cidr_blocks   = optional(list(string), ["0.0.0.0/0"]) # CIDR blocks for SSH access
    additional_tags   = optional(map(string), {})             # Additional tags for instances
  })

  default = {
    create_instance = false
  }
}
