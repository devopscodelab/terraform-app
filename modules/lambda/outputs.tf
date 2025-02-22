
output "lambda_function_arn" {
  value = aws_lambda_function.list_buckets.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.list_buckets.function_name
}
