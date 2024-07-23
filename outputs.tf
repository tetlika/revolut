output "lambda_function_arn" {
  value = aws_lambda_function.hello_function.arn
}

output "api_gateway_url" {
  value = aws_api_gateway_stage.stage.invoke_url
}
