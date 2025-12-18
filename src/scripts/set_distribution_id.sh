#!/bin/bash
echo "export DISTRIBUTION_ID=$(pulumi stack output stack --json --stack "$STACK_NAME" | jq '.distribution.id')" >>"$BASH_ENV"
