resource "aws_lambda_function" "hello_function" {
  filename         = "function.zip"
  function_name    = var.function_name
  role             = var.environment == "localstack" ? "arn:aws:iam::000000000000:role/lambda-execution-role" : aws_iam_role.lambda_execution_role[0].arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("function.zip")
  environment {
    variables = {
      TABLE_NAME          = aws_dynamodb_table.users.name
      LOCALSTACK_ENDPOINT = var.environment == "localstack" ? var.localstack_endpoint : null
    }
  }
}