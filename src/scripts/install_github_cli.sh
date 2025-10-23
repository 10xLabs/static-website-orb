#!/bin/bash

wget https://github.com/cli/cli/releases/download/v2.62.0/gh_2.62.0_linux_amd64.deb
sudo dpkg -i gh_2.62.0_linux_amd64.deb
echo "$GITHUB_PAT" > github_pat.txt
gh auth login --with-token < github_pat.txt
