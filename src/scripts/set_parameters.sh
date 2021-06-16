value=$(aws ssm get-parameter --name "/$ENVIRONMENT/$CIRCLE_PROJECT_REPONAME/PARAMETERS" | jq '.Parameter.Value' | tr -d \")
readarray -t values <<<"$value"

for val in "${values[@]}"
do
    echo "$val"
	echo "export $val" >> "$BASH_ENV"
done
