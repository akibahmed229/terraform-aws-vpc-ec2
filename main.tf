# VPC Resource
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_config.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_config.name
  }
}

# Subnets (Public and Private)
resource "aws_subnet" "main" {
  vpc_id   = aws_vpc.main.id
  for_each = var.subnet_config # key={cidr=,azs=} each.key each.value

  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.azs
  map_public_ip_on_launch = each.value.public # Auto-assign public IP for public subnets

  tags = {
    Name = each.key
  }
}

# Local values to separate public and private subnets
locals {
  public_subnet = {
    # key = {} if public is true in subnet_config
    for key, config in var.subnet_config : key => config if config.public
  }
  private_subnet = {
    # key = {} if public is true in subnet_config
    for key, config in var.subnet_config : key => config if !config.public
  }

  public_subnet_ids = [
    for key, config in var.subnet_config : aws_subnet.main[key].id if config.public
  ]
  private_subnet_ids = [
    for key, config in var.subnet_config : aws_subnet.main[key].id if !config.public
  ]

  target_subnet_ids = length(local.public_subnet_ids) > 0 ? local.public_subnet_ids : local.private_subnet_ids
}

# Internet Gateway (only if there are public subnets)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  count  = length(local.public_subnet) > 0 ? 1 : 0

  tags = {
    Name = "${var.vpc_config.name}-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  count  = length(local.public_subnet) > 0 ? 1 : 0

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }

  tags = {
    Name = "${var.vpc_config.name}-public-rt"
  }
}

# Associate Public Route Table with Public Subnets
resource "aws_route_table_association" "public" {
  for_each = local.public_subnet # public_subnet={} private_subnet={}

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.public[0].id
}

# security group for ec2 instance 
resource "aws_security_group" "ec2" {
  count       = var.ec2_config.create_instance ? 1 : 0
  name        = "${var.vpc_config.name}-ec2-sg"
  description = "Security group for EC2 instances in ${var.vpc_config.name}"
  vpc_id      = aws_vpc.main.id

  # Allow SSH from anywhere (adjust as needed)
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = var.ec2_config.ssh_cidr_blocks
    description = "SSH access"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.vpc_config.name}-ec2-sg"
  }
}

# EC2 Instance (optional, based on configuration)
resource "aws_instance" "main" {
  count                  = var.ec2_config.create_instance ? var.ec2_config.instance_count : 0
  ami                    = var.ec2_config.ami_id
  instance_type          = var.ec2_config.instance_type
  subnet_id              = element(local.target_subnet_ids, count.index)
  vpc_security_group_ids = [aws_security_group.ec2[0].id]
  key_name               = var.ec2_config.key_name

  tags = merge({
    Name = "${var.ec2_config.name_prefix}-${count.index + 1}"
    },
    var.ec2_config.additional_tags
  )
}
