
variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "container_port" {
  description = "Port on which the container is listening"
  type        = number
  default     = 5000
}

variable "health_check_path" {
  description = "Health check path for the default target group"
  type        = string
  default     = "/"
}
