value=$(aws ssm get-parameter --name "/$ENVIRONMENT/$CIRCLE_PROJECT_REPONAME/PARAMETERS" --region "$AWS_DEFAULT_REGION" --with-decryption | jq '.Parameter.Value' | tr -d \")
readarray -t values <<<"$value"

for val in "${values[@]}"
do
    echo "**************************"
    echo "$val"
    echo "**************************"
    echo "export $val" >> "$BASH_ENV"
done

cat "$BASH_ENV"