
output "github_secret_arn" {
  value = aws_secretsmanager_secret.secrets["github"].arn
}

output "application_secret_arn" {
  value = aws_secretsmanager_secret.secrets["application"].arn
}
