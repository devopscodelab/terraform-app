terraform {
  backend "s3" {
    bucket         = "terraform-state-lock-pflegia"
    key            = "terraform/state/pflegia-infra.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  project_name       = var.project_name
  environment        = var.environment
}

module "ecr" {
  source = "./modules/ecr"
  repository_name = var.ecr_repository_name
  project_name   = var.project_name
  environment    = var.environment
}

module "ecs" {
  source = "./modules/ecs"
  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  ecr_repository_url = module.ecr.repository_url
  container_port  = var.container_port
}

module "cicd" {
  source = "./modules/cicd"
  project_name           = var.project_name
  environment            = var.environment
  repository_name        = var.github_repository_name
  branch_name           = var.github_branch_name
  ecr_repository_url    = module.ecr.repository_url
  ecs_cluster_name      = module.ecs.cluster_name
  ecs_service_name      = module.ecs.service_name
  alb_listener_arn      = module.ecs.alb_listener_arn
  blue_target_group_name = module.ecs.blue_target_group_name
  green_target_group_name = module.ecs.green_target_group_name
}