This code works for both local and AWS deployment. By default it is configured to use local environment.

AWS diagram is here:

https://github.com/tetlika/revolut/blob/main/diagram.png

To start using Run setup script:

`./setup.sh`

Find container with name localstack, e.g.:

`docker ps`

`CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS                    PORTS                                                                     NAMES
7acd4d7e2e10   localstack/localstack   "docker-entrypoint.sh"   49 seconds ago   Up 48 seconds (healthy)   0.0.0.0:4566->4566/tcp, 4510-4559/tcp, 5678/tcp, 0.0.0.0:4571->4571/tcp   revolut-localstack-1`

Enter container, e.g.:

`docker exec -it 7acd4d7e2e10 bash`

Navigate to /opt/app:

`cd /opt/app`

and run deploy.sh script:

`./deploy.sh`

Type yes when doing terraform apply:

Enter a value: yes

Example of terraform output:

`Outputs:

api_gateway_url = "https://el0a559qum.execute-api.us-west-2.amazonaws.com/dev"
lambda_function_arn = "arn:aws:lambda:us-west-2:000000000000:function:hello-function"`

Note this part of api_gateway_url in this example - el0a559qum ; it will be different for your setup. 

In order to test:

`export API_ID="el0a559qum"
export ENDPOINT="http://localhost:4566/restapis/$API_ID/test/_user_request_/hello"`

Run tests script:

`python tests.py`

In order to deploy changed lambda function in localhost - make changes to lambda_function.py and run deploy script again - it will redeploy lambda function with your changes.

AWS deployment

in order to deploy to aws change variable to aws, and run setup.sh on host on which docker is running
enter localstack container and export AWS creds:

export AWS_ACCESS_KEY_ID=AKIA...
export AWS_SECRET_ACCESS_KEY="KQ1..."


Example of terraform output when creating resources in AWS:

api_gateway_url = "https://5a6mb1dhca.execute-api.us-west-2.amazonaws.com/dev"
lambda_function_arn = "arn:aws:lambda:us-west-2:905418023427:function:hello-function"

Example of request to AWS API:

User creation:

curl -X PUT "https://vetzzyrdoa.execute-api.us-west-2.amazonaws.com/dev/hello/johndoe"   -H "Content-Type: application/json"   -d '{"dateOfBirth": "1990-01-01"}'

Getting user info:

curl -X GET  "https://5a6mb1dhca.execute-api.us-west-2.amazonaws.com/dev/hello/johndoe"
