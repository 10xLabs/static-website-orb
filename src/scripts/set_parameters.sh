#!/bin/bash

value=$(aws ssm get-parameter --name "/$CIRCLE_PROJECT_REPONAME/PARAMETERS" --region "$AWS_DEFAULT_REGION" --with-decryption | jq '.Parameter.Value' | tr -d \")
echo "$value"
IFS="|" read -r -a values <<< "$value"
for val in "${values[@]}"
do
    echo "export $val" >> "$BASH_ENV"
    echo "$val"
done
