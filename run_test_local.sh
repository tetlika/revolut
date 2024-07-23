#!/bin/bash -ex

export STAGE="dev"
export API_NAME="DevAPI"
export DEV_REGION="us-west-2"
export FUNCTION_NAME="helloFunction"
export URI_PATH="hello"
export ROLE_ARN="arn:aws:iam::000000000000:role/lambda-role"

rm -rf function.zip
zip function.zip lambda_function.py

# Create the Lambda function
aws --endpoint-url=http://localhost:4566 lambda create-function \
  --function-name ${FUNCTION_NAME} \
  --runtime python3.8 \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://function.zip \
  --role ${ROLE_ARN} \
  --region ${DEV_REGION}

# Create DynamoDB table
aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name users \
    --attribute-definitions AttributeName=username,AttributeType=S \
    --key-schema AttributeName=username,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --region ${DEV_REGION}

# Create the REST API
export API_ID=$(aws --endpoint-url=http://localhost:4566 apigateway create-rest-api \
                --name ${API_NAME} --query 'id' --output text --region ${DEV_REGION})

# create resources
export ROOT_ID=$(aws --endpoint-url=http://localhost:4566 apigateway get-resources \
                 --rest-api-id ${API_ID} --query 'items[0].id' --output text --region ${DEV_REGION})

export RESOURCE_ID_PARENT=$(aws --endpoint-url=http://localhost:4566 apigateway create-resource \
                            --rest-api-id ${API_ID} --parent-id ${ROOT_ID} --path-part ${URI_PATH} \
                            --query 'id' --output text --region ${DEV_REGION})

export RESOURCE_ID=$(aws --endpoint-url=http://localhost:4566 apigateway create-resource \
                     --rest-api-id ${API_ID} --parent-id ${RESOURCE_ID_PARENT} --path-part "{username}" \
                     --query 'id' --output text --region ${DEV_REGION})


aws apigateway put-method --rest-api-id ${API_ID} \
                          --resource-id ${RESOURCE_ID} \
                          --http-method PUT \
                          --authorization-type "NONE" \
                          --endpoint-url=http://localhost:4566 \
                          --region ${DEV_REGION}

aws apigateway put-method --rest-api-id ${API_ID} \
                          --resource-id ${RESOURCE_ID} \
                          --http-method GET \
                          --authorization-type "NONE" \
                          --endpoint-url=http://localhost:4566 \
                          --region ${DEV_REGION}

# Create a Lambda function integrations, deployment
aws apigateway put-integration --rest-api-id ${API_ID} \
                               --resource-id ${RESOURCE_ID} \
                               --http-method PUT \
                               --type AWS_PROXY \
                               --integration-http-method POST \
                               --uri arn:aws:apigateway:${DEV_REGION}:lambda:path/2015-03-31/functions/arn:aws:lambda:${DEV_REGION}:000000000000:function:${FUNCTION_NAME}/invocations --endpoint-url=http://localhost:4566 --region ${DEV_REGION}

aws apigateway put-integration --rest-api-id ${API_ID} \
                               --resource-id ${RESOURCE_ID} \
                              --http-method GET \
                              --type AWS_PROXY \
                              --integration-http-method POST \
                              --uri arn:aws:apigateway:${DEV_REGION}:lambda:path/2015-03-31/functions/arn:aws:lambda:${DEV_REGION}:000000000000:function:${FUNCTION_NAME}/invocations --endpoint-url=http://localhost:4566 --region ${DEV_REGION}

aws apigateway create-deployment --rest-api-id $API_ID \
                                 --stage-name ${STAGE} \
                                 --endpoint-url=http://localhost:4566 \
                                 --region ${DEV_REGION}


export ENDPOINT="http://localhost:4566/restapis/$API_ID/test/_user_request_/hello"

python tests.py