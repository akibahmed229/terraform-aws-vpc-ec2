# Contributing to terraform-aws-vpc-ec2

First off, thank you for considering contributing to this Terraform module! 🎉

## Code of Conduct

This project adheres to a Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- **Clear title and description**
- **Terraform version** (`terraform version`)
- **AWS provider version**
- **Steps to reproduce** the issue
- **Expected vs actual behavior**
- **Code samples** (if applicable)
- **Error messages** (full output)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- Use a **clear and descriptive title**
- Provide a **detailed description** of the proposed functionality
- Explain **why this enhancement would be useful**
- Include **code examples** if applicable

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Follow the coding standards** (see below)
3. **Add tests** if you're adding functionality
4. **Update documentation** (README, examples, comments)
5. **Ensure the test suite passes** (`terraform fmt`, `terraform validate`)
6. **Write meaningful commit messages**
7. **Submit your pull request**

## Development Workflow

### Setup

```bash
# Clone your fork
git clone https://github.com/YOUR-USERNAME/terraform-aws-vpc-ec2.git
cd terraform-aws-vpc-ec2

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL-USERNAME/terraform-aws-vpc-ec2.git

# Create a new branch
git checkout -b feature/my-new-feature
```

### Coding Standards

- **Terraform Formatting**: Run `terraform fmt -recursive` before committing
- **Variable Naming**: Use descriptive snake_case names
- **Comments**: Add comments for complex logic
- **Validation**: Add input validation where appropriate
- **Outputs**: Document all outputs clearly
- **Examples**: Update examples if changing functionality

### Testing

```bash
# Format check
terraform fmt -check -recursive

# Initialize
terraform init

# Validate
terraform validate

# Plan (in examples)
cd examples/basic-vpc
terraform plan
```

### Documentation

- Update `README.md` for new features
- Add examples in the `examples/` directory
- Update `CHANGELOG.md` following [Keep a Changelog](https://keepachangelog.com/)
- Add inline comments for complex code

### Commit Messages

Follow conventional commits:

```
feat: add support for NAT gateway
fix: correct subnet CIDR validation
docs: update README with new examples
test: add validation for EC2 configuration
chore: update Terraform version requirement
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

## Release Process

1. Update `CHANGELOG.md` with new version
2. Update version in `README.md` examples
3. Create a git tag: `git tag -a v1.1.0 -m "Release v1.1.0"`
4. Push tag: `git push origin v1.1.0`
5. Create GitHub release from tag

## Questions?

Feel free to open an issue with the `question` label or reach out to the maintainers.

---

Thank you for contributing! 🙏
