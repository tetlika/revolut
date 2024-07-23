#!/bin/bash

rm -rf terraform.tfstate terraform.tfstate.backup .terraform .terraform.lock.hcl

docker-compose down --rmi all -v --remove-orphans || true
docker-compose up -d 
