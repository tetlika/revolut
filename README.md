# Hello API

This repository contains a simple "Hello" application that can be deployed both locally and on AWS. By default, it is configured to use the local environment. 

On local environment - localstack is used to emulate DynamoDB, Lambda and API gateway functionality (see https://hub.docker.com/r/localstack/localstack).

Main benefit of this setup, is that same terraform and application code is used to deploy code to AWS and to local environment. 

To which environment deploy is regulated by variable https://github.com/tetlika/revolut/blob/main/vars.tf#L23, this variable should be set to "aws" when deploying to AWS.

![AWS Architecture Diagram](https://github.com/tetlika/revolut/blob/main/diagram.png)

## Getting Started

### Prerequisites

- Docker
- docker-compose

Setup was tested on MacOS

### Setup

1. **Run the setup script:**

    ```sh
    ./setup.sh
    ```

2. **Find the LocalStack container:**

    ```sh
    docker ps
    ```

    Example output:

    ```plaintext
    CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS                    PORTS                                                                     NAMES
    7acd4d7e2e10   localstack/localstack   "docker-entrypoint.sh"   49 seconds ago   Up 48 seconds (healthy)   0.0.0.0:4566->4566/tcp, 4510-4559/tcp, 5678/tcp, 0.0.0.0:4571->4571/tcp   revolut-localstack-1
    ```

3. **Enter the LocalStack container:**

    ```sh
    docker exec -it 7acd4d7e2e10 bash
    ```

4. **Navigate to `/opt/app` and run the deploy script:**

    ```sh
    cd /opt/app
    ./deploy.sh
    ```

5. **Type `yes` when prompted during `terraform apply`:**

    ```plaintext
    Enter a value: yes
    ```

6. **Example local Terraform Output:**

    ```Outputs:

    api_gateway_url = "https://el0a559qum.execute-api.us-west-2.amazonaws.com/dev"
    lambda_function_arn = "arn:aws:lambda:us-west-2:000000000000:function:hello-function"
    ```

6. **Testing:**

    Use above output api_gateway_url to set API_ID:

    ```export API_ID="el0a559qum"
    export ENDPOINT="http://localhost:4566/restapis/$API_ID/test/_user_request_/hello"
    python tests.py
    ```
7. **Redeploy Lambda Function:**

   While doing local development of lambda function - make changes to it and run deploy script once more - the changes will be picked up.
