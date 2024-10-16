#!/bin/bash
echo "export BUCKET_NAME=$(pulumi stack output stack --json --cwd "$WORKING_DIRECTORY" --stack "$STACK_NAME" | jq '.bucket.name')" >>"$BASH_ENV"
