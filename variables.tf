variable "aws_region" {
  description = "AWS region where resources will be created (default: us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "pflegia"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC - defines the IP address range for entire network"
  type        = string
  default     = "10.100.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.100.1.0/24", "10.100.2.0/24"]
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "pflegia-app"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 5000
}



variable "app_secret" {
  description = "Application secret key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "database_url" {
  description = "Database connection URL"
  type        = string
  sensitive   = true
  default     = ""
}

variable "github_token" {
  description = "GitHub token for repository access"
  type        = string
  sensitive   = true
  default     = ""
}
