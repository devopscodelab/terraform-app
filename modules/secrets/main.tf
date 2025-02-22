
locals {
  secrets = {
    github = {
      github_token     = var.github_token
      ecr_repository   = var.ecr_repository_url
      aws_region       = var.aws_region
    }
    application = {
      app_secret       = var.app_secret
      database_url     = var.database_url
    }
  }
}

resource "aws_secretsmanager_secret" "secrets" {
  for_each = local.secrets
  name     = "${var.project_name}-${var.environment}-${each.key}"
}

resource "aws_secretsmanager_secret_version" "secret_values" {
  for_each      = local.secrets
  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = jsonencode(each.value)
}
