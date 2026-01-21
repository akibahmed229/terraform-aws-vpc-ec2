# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Initial module release
- VPC creation with custom CIDR blocks
- Public and private subnet support
- Internet Gateway for public subnets
- Optional EC2 instance creation
- Security groups for EC2 instances
- Multi-AZ instance distribution
- Comprehensive outputs
- Example configurations
- CI/CD pipeline with GitHub Actions
- Terraform validation and security scanning

## [1.0.0] - 2025-01-22

### Added

- First stable release
- Production-ready VPC module
- EC2 integration with flexible configuration
- Documentation and examples
- Security best practices

### Changed

- N/A

### Deprecated

- N/A

### Removed

- N/A

### Fixed

- N/A

### Security

- Configurable SSH CIDR restrictions
- Security group with minimal required permissions

[Unreleased]: https://github.com/YOUR-USERNAME/terraform-aws-vpc-ec2/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/YOUR-USERNAME/terraform-aws-vpc-ec2/releases/tag/v1.0.0
