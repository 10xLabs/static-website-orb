#!/bin/bash

wget https://github.com/cli/cli/releases/download/v2.82.1/gh_2.82.1_linux_amd64.deb
sudo dpkg -i gh_2.82.1_linux_amd64.deb
echo "$GITHUB_PAT" > github_pat.txt
gh auth login --with-token < github_pat.txt
