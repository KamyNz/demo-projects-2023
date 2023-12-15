# 🚀 Terraform Project with Modules 🛠️

This Terraform project demonstrates the use of modules to create a network infrastructure and deploy EC2 instances, an Application Load Balancer (ALB), and an S3 bucket. It sets up networking configurations, EC2 instances with ALB, and an S3 bucket within an AWS environment.

## Project Structure

The project directory structure looks like this:

```
.
├── networking/
│   └── ... # Contains the networking module configurations
├── ec2-alb/
│   └── ... # Contains the EC2 with ALB module configurations
├── s3/
│   └── ... # Contains the S3 module configurations
├── main.tf # Main Terraform configuration file
├── variables.tf # Variable declarations
├── outputs.tf # Output definitions
└── README.md # You are here 🙂
```

## Terraform Configuration

The `main.tf` file contains the module declarations used in this project:

```hcl
# Using module NETWORKING
module "networking" {
  source                    = "./networking"
  owner                     = var.owner
  OTU                       = var.OTU
  # Other variables...
}

# Using module EC2
module "ec2-alb" {
  source                               = "./ec2-alb"
  vpc_id                               = module.networking.vpc_id
  aws_subnet_public_id                 = module.networking.aws_subnet_public_id
  # Other variables...
}

module "s3" {
  source             = "./s3"
  owner              = var.owner
  OTU                = var.OTU
  # Other variables...
}
```

## Usage

To use this Terraform project, follow these steps:

1. **Formatting**: Run `terraform fmt` to format the configuration files.
2. **Initialization**: Execute `terraform init` to initialize the project and download the required providers.
3. **Planning**: Run `terraform plan` to preview the infrastructure changes that will be applied.
4. **Applying Changes**: Execute `terraform apply` and input `yes` when prompted to apply the changes.

### Destroying Infrastructure

To destroy the infrastructure, use the command:

```bash
terraform destroy --auto-approve
```

⚠️ **Note:** The `destroy` command will irreversibly remove all created resources. Proceed with caution.

Feel free to adjust the variables in `variables.tf` according to your requirements before running Terraform commands.

Have fun terraforming! 🌍✨
