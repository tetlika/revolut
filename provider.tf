provider "aws" {
  region                      = var.region
  access_key                  = var.environment == "localstack" ? "mock_access_key" : null
  secret_key                  = var.environment == "localstack" ? "mock_secret_key" : null
  skip_credentials_validation = var.environment == "localstack"
  skip_requesting_account_id  = var.environment == "localstack"
  endpoints {
    dynamodb = var.environment == "localstack" ? var.localstack_endpoint : null
    lambda   = var.environment == "localstack" ? var.localstack_endpoint : null
    apigateway = var.environment == "localstack" ? var.localstack_endpoint : null
  }
}

