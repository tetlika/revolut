#!/bin/bash -ex

if [ ! -f /bin/terraform ]; then
    echo "Terraform is not installed. Installing..."

    apt-get update
    apt-get install -y wget unzip

    wget https://releases.hashicorp.com/terraform/1.9.2/terraform_1.9.2_linux_amd64.zip -O terraform.zip
    unzip terraform.zip
    mv terraform /bin/
    chmod +x /bin/terraform
    rm -rf terraform.zip LICENSE.txt

    echo "Terraform has been installed successfully."
else
    echo "Terraform is already installed."
fi

rm -rf function.zip
zip function.zip lambda_function.py

terraform init
terraform apply
