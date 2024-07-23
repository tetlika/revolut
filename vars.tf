variable "region" {
  default = "us-west-2"
}

variable "table_name" {
  default = "users"
}

variable "function_name" {
  default = "hello-function"
}

variable "api_gateway_name" {
  default = "hello-api"
}

variable "lambda_role_name" {
  default = "lambda-execution-role"
}

variable "environment" {
  description = "Deployment environment (localstack or aws)"
  default     = "localstack"
}

variable "localstack_endpoint" {
  description = "LocalStack endpoint URL"
  default     = "http://localhost:4566"
}
