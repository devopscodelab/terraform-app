
provider "aws" {
  region = "us-east-1"
}

locals {
  project_name    = "pflegia"
  environment     = "prod"
  unique_suffix   = formatdate("YYYYMMDD", timestamp())
  
  # Create unique names for S3 and DynamoDB
  s3_bucket_name  = lower("${local.project_name}-terraform-state-${local.environment}-${local.unique_suffix}")
  dynamodb_name   = lower("${local.project_name}-tfstate-lock-${local.environment}")
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.s3_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = local.s3_bucket_name
    Environment = local.environment
    Project     = local.project_name
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = local.dynamodb_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = local.dynamodb_name
    Environment = local.environment
    Project     = local.project_name
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_state_lock.name
}
