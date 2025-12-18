#!/bin/bash
echo "export BUCKET_NAME=$(pulumi stack output stack --json --stack "$STACK_NAME" | jq '.bucket.name')" >>"$BASH_ENV"
