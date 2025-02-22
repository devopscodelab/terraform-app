
# Pflegia Infrastructure

This repository contains Terraform configurations for Pflegia's AWS infrastructure.

## Infrastructure Components

- VPC (CIDR: 10.100.0.0/16)
- ECS Fargate Cluster with Blue-Green Deployment
- Application Load Balancer
- ECR Repository
- Lambda Function with API Gateway
- AWS Secrets Manager
- S3 and DynamoDB for Terraform State

## Getting Started

1. Deploy Remote State Infrastructure:
```bash
cd bootstrap
terraform init
terraform apply
```

2. Deploy Main Infrastructure:
```bash
cd ..
terraform init
terraform apply
```

## State Management

- State files are stored in S3 with versioning enabled
- State locking using DynamoDB
- Unique bucket name format: `pflegia-terraform-state-prod-YYYYMMDD`
- DynamoDB table name format: `pflegia-tfstate-lock-prod`

## Secrets Management

Two categories of secrets are managed:
1. GitHub Actions secrets (tokens, ECR repository URL)
2. Application secrets (app secrets, database URLs)

## Networking

- VPC CIDR: 10.100.0.0/16
- Public Subnets: 10.100.1.0/24, 10.100.2.0/24
- Blue-Green deployment enabled for zero-downtime updates

## Security

- Encrypted S3 state bucket (AES-256)
- Secrets stored in AWS Secrets Manager
- IAM roles with least privilege access
