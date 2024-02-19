#!/bin/bash

z="node.yml"

for f in $(find .. -type f); do
    # echo "$f"
    if [[ $f =~ $z ]]; then
        echo "$f"
    # else
    #     # echo "Not proper format"
    fi
done

source_directory='|public|'
include_directories='|public|'
exclude_directories='|index.html|'
cache_control='|public, max-age=31536000, immutable|'
content_encoding='|gzip|'
content_type='|text/html; charset=utf-8|'
