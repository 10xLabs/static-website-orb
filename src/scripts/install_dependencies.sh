#!/bin/bash

echo  "//npm.pkg.github.com/:_authToken=$GITHUB_PAT" > ./.npmrc
echo  "@10xLabs:registry=$NPM_GITHUB_REGISTRY" >> ./.npmrc
echo "registry=https://registry.npmjs.org" >> ./.npmrc

npm install
