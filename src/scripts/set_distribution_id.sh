#!/bin/bash
echo "export DISTRIBUTION_ID=$(pulumi stack output stack --json --cwd "$WORKING_DIRECTORY" --stack "$STACK_NAME" | jq '.distribution.id')" >>"$BASH_ENV"
