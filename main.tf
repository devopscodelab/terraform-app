# Configure Terraform backend for state management
# S3 for state storage and DynamoDB for state locking
terraform {
  backend "s3" {
    bucket         = "pflegia-terraform-state-prod-20250222"  # Update this with the output from bootstrap
    key            = "terraform/state/pflegia-infra.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "pflegia-tfstate-lock-prod"  # Update this with the output from bootstrap
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Module: Creates the networking infrastructure
# Including VPC, public subnets, internet gateway, and route tables
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  project_name       = var.project_name
  environment        = var.environment
}

# ECR Module: Sets up container registry for Docker images
module "ecr" {
  source = "./modules/ecr"
  repository_name = var.ecr_repository_name
  project_name   = var.project_name
  environment    = var.environment
}

# ALB Module: Manages Application Load Balancer for blue-green deployment
module "alb" {
  source = "./modules/alb"
  project_name      = var.project_name
  environment       = var.environment
  vpc_id           = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  container_port    = var.container_port
}

# ECS Module: Manages container orchestration
# Sets up ECS cluster, service, task definitions, and load balancer
module "ecs" {
  source = "./modules/ecs"
  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  ecr_repository_url = module.ecr.repository_url
  container_port  = var.container_port
}

# Secrets Manager Module: Manages application and GitHub secrets
module "secrets" {
  source            = "./modules/secrets"
  project_name      = var.project_name
  environment       = var.environment
  github_token      = var.github_token
  ecr_repository_url = module.ecr.repository_url
  aws_region        = var.aws_region
  app_secret        = var.app_secret
  database_url      = var.database_url
}

# Lambda Module: Creates Lambda function to list S3 buckets
module "lambda" {
  source = "./modules/lambda"
  project_name = var.project_name
  environment  = var.environment
}

# API Gateway Module: Creates HTTP API Gateway
module "api_gateway" {
  source = "./modules/api_gateway"
  project_name = var.project_name
  environment  = var.environment
  lambda_function_arn = module.lambda.lambda_function_arn
  lambda_function_name = module.lambda.lambda_function_name
}