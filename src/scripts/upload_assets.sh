#!/bin/bash

CONFIG_FILE="upload.config.json"

upload_to_s3() {
    local source_dir=$1
    local include_dirs=$2
    local exclude_dirs=$3
    local cache_control=$4
    local content_encoding=$5
    local content_type=$6

    CMD="aws s3 sync $source_dir s3://$BUCKET_NAME/$RELEASE_TAG/"

    for dir in $(echo "$include_dirs" | jq -r '.[]'); do
        CMD="$CMD --include \"$dir\""
    done

    for dir in $(echo "$exclude_dirs" | jq -r '.[]'); do
        CMD="$CMD --exclude \"$dir\""
    done

    if [[ ! -z "$cache_control" ]]; then
        CMD="$CMD --cache-control \"$cache_control\""
    fi

    if [[ ! -z "$content_encoding" ]]; then
        CMD="$CMD --content-encoding \"$content_encoding\""
    fi

    if [[ ! -z "$content_type" ]]; then
        CMD="$CMD --content-type \"$content_type\""
    fi

    echo "$CMD"
    eval $CMD
}

for row in $(jq -c '.[]' $CONFIG_FILE); do
    source_dir=$(echo $row | jq -r '.sourceDirectory')
    include_dirs=$(echo $row | jq -r '.includeDirectories // empty')
    exclude_dirs=$(echo $row | jq -r '.excludeDirectories // empty')
    cache_control=$(echo $row | jq -r '.cacheControl // empty')
    content_encoding=$(echo $row | jq -r '.contentEncoding // empty')
    content_type=$(echo $row | jq -r '.contentType // empty')

    upload_to_s3 "$source_dir" "$include_dirs" "$exclude_dirs" "$cache_control" "$content_encoding" "$content_type"
done

aws s3 sync "s3://$BUCKET_NAME/$RELEASE_TAG/" "s3://$BUCKET_NAME/latest/"
