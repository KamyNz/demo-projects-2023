## Terraform Commands Cheat Sheet 🔑📋

### Initialization 🔧
```bash
# To initiate Terraform project
terraform init
```

### Planning and Applying Changes 📝
```bash
# Check plan
terraform plan

# Create resources and prompt for approval
terraform apply

# Create resources without asking for approval
terraform apply --auto-approve

# Apply changes to a specific target
terraform apply -target <whole_resource_id>

# Apply changes to replace a specific target
terraform apply --replace <whole_resource_object>

# Apply changes with refresh only
terraform apply -refresh-only
```

### Destruction ☠️
```bash
# Destroy resources
terraform destroy
```

### State Management and Output 📄
```bash
# List Terraform managed resources
terraform state list

# Show specific content of a resource
terraform state show <example: aws_eip.one>

# Show Terraform outputs
terraform output
```

### Formatting and Debugging 🛠️🔍
```bash
# Organize formatting of .tf files
terraform fmt

# Refresh Terraform state
terraform refresh

# Use Terraform console
terraform console

# Use Terraform console with specific variables file
terraform console -var-file="dev.tfvars"
```

### Extracting Information with Bash Commands 💻
```bash
# Extract specific information from Terraform state
terraform state show aws_instance.mlflow-demo-tf | grep "public_ip"
```
