#!/bin/sh
#

if [ $# -lt 2 ]; then
    echo "Usage: $0 new_image prev_image"
    exit 1
fi

new_image=$1
prev_image=$2

DELIMITER=","
CACHE_FILE="${PWD}/imgdiff.cache"

if [ ! -f "${CACHE_FILE}" ]; then
    touch "${CACHE_FILE}"
fi

cache_updated(){
    query_item="$1"
    query_hash=$(git hash-object "$query_item")
    # Check if the item exists in the cache file
    cache_item=$(grep "^${query_item}" "$CACHE_FILE")
    if [ -n "$cache_item" ]; then
        cache_hash=$(echo "$cache_item" | awk -F"$DELIMITER" '{print $2}')
        if [ "$query_hash" = "$cache_hash" ]; then
            return $([ $(echo "$cache_item" | awk -F"$DELIMITER" '{print $3}') -eq 0 ] && echo 0 || echo 1)
        fi
    fi
    return 2 # not found
}

insert_or_update_cache(){
    query_item="$1"
    is_changed=$2
    cache_item=$(grep "^${query_item}" "$CACHE_FILE")
    if [ -n "$cache_item" ]; then
        # update
        sed -i "\#^${cache_item}#d" "$CACHE_FILE"
        ret=$?
        if [ $ret -eq 0 ]; then
            # Add the new item to the cache file
            echo "$query_item$DELIMITER$query_hash$DELIMITER$is_changed" >> "$CACHE_FILE"
        else
            echo "when update cache item: "
            echo "$query_item"
            echo "sed return $ret"
            echo "Cache file update failed. Exiting..."
            exit 1
        fi
    else
        # insert
        echo "$query_item$DELIMITER$query_hash$DELIMITER$is_changed" >> "$CACHE_FILE"
    fi
}

cache_updated "${new_image}"
ret=$?
if [ $ret -ne 2 ]; then # exists in cache
    if [ $ret -eq 0 ]; then
        # unchanged
        exit 0
    elif [ $ret -eq 1 ]; then
        # changed
        echo $1
        exit 0
    fi
else
    new_image_size=$(exiftool -ImageSize -b -s3 "${new_image}")
    prev_image_size=$(exiftool -ImageSize -b -s3 "${prev_image}")
    changed=0
    if [ "$new_image_size" != "$prev_image_size" ]; then
        # quick reject by check the two image size using exiftool
        changed=1
    else
        output=$(compare "${prev_image}" "${new_image}" NULL)
        status=$?
        if [ $status -ne 0 ]; then
            changed=1
        fi
    fi
    insert_or_update_cache "${new_image}" $changed
    if [ $changed -eq 1 ]; then
        echo $1
    fi
fi
