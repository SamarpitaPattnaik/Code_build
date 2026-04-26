# Terraform Infrastructure as Code — EC2, VPC, S3 & DynamoDB State Locking

## Overview

This project provisions the following AWS resources using Terraform modules:

| Resource         | Module              | Description                              |
|------------------|---------------------|------------------------------------------|
| VPC              | `module/vpc`        | VPC, public subnet, IGW, route table     |
| EC2              | `module/ec2`        | Amazon Linux 2 instance + security group |
| S3               | `module/s3`         | Remote state bucket (encrypted, versioned)|
| DynamoDB         | `module/dynamodb`   | State locking table                      |

## Project Structure

```
terraform_full_project/
├── main.tf               # Root module — wires all child modules
├── provider.tf           # AWS provider & Terraform version constraints
├── backend.tf            # S3 + DynamoDB remote backend configuration
├── variables.tf          # Root input variables
├── terraform.tfvars      # Variable values
├── outputs.tf            # Root outputs
├── buildspec.yaml        # AWS CodeBuild CI/CD pipeline spec
└── module/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── s3/
    │   ├── main.tf       # Versioning, encryption, public-access block, lifecycle
    │   ├── variables.tf
    │   └── outputs.tf
    └── dynamodb/
        ├── main.tf       # PAY_PER_REQUEST, SSE, PITR enabled
        ├── variables.tf
        └── outputs.tf
```

## Prerequisites

- Terraform >= 1.3.0
- AWS CLI configured with appropriate IAM permissions
- An S3 bucket and DynamoDB table already created for the backend (bootstrap step below)

## Bootstrap (First-Time Setup)

> The S3 bucket and DynamoDB table in `backend.tf` must exist **before** enabling remote state.

**Step 1:** Comment out `backend.tf` content and run locally with a local backend:
```bash
terraform init
terraform apply -target=module.s3 -target=module.dynamodb
```

**Step 2:** Uncomment `backend.tf` and migrate state:
```bash
terraform init -migrate-state
```

## Usage

```bash
# Initialise
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply

# Destroy all resources
terraform destroy
```

## S3 State Bucket Features

- **Versioning** — every state revision is retained
- **AES-256 encryption** — server-side encryption enabled
- **Public access block** — all four public-access flags set to `true`
- **Access logging** — logs written to a companion `-logs` bucket
- **Lifecycle rule** — non-current versions expire after 90 days

## DynamoDB Lock Table Features

- **PAY_PER_REQUEST** billing — no capacity planning needed
- **Point-in-time recovery (PITR)** — enabled
- **Server-side encryption** — enabled
- Hash key: `LockID` (required by Terraform)

## CodeBuild (CI/CD)

The `buildspec.yaml` automates the full Terraform lifecycle:
1. Installs Terraform
2. Runs `terraform init` + `terraform validate`
3. Runs `terraform plan` (saves plan artifact)
4. Runs `terraform apply`
