#!/bin/bash

echo "export STACK_NAME=$CIRCLE_PROJECT_REPONAME.$ENVIRONMENT" >> "$BASH_ENV"
