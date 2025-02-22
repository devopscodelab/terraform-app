
variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "github_token" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "app_secret" {
  type    = string
  default = ""
}

variable "database_url" {
  type    = string
  default = ""
}
